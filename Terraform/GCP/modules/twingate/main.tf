resource "twingate_remote_network" "network" {
  name     = var.remote_network_name
  location = "GOOGLE_CLOUD"
}

# ############################################
# ##        CREATE TWINGATE CONNECTOR       ##
# ############################################

resource "twingate_connector" "connector" {
  count             = var.twingate_instances_count
  name              = "twingate-${var.environment}-${count.index}"
  remote_network_id = twingate_remote_network.network.id
}

# ###########################################
# ##        TWINGATE CONNECTOR TOKENS      ##
# ###########################################

resource "twingate_connector_tokens" "tokens" {
  count        = length(twingate_connector.connector)
  connector_id = twingate_connector.connector[count.index].id
}

#########################################################
##        TWINGATE CONNECTOR CONTAINER INSTANCES       ##
#########################################################

module "container" {
  count = var.twingate_instances_count

  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.2"

  container = {
    image = "docker.io/twingate/connector:${var.twingate_image_version}"

    securityContext = {
      privileged : true
    }

    env = [
      {
        name  = "TWINGATE_NETWORK"
        value = var.twingate_network_name
      },
      {
        name  = "TWINGATE_ACCESS_TOKEN"
        value = twingate_connector_tokens.tokens[count.index].access_token
      },
      {
        name  = "TWINGATE_REFRESH_TOKEN"
        value = twingate_connector_tokens.tokens[count.index].refresh_token
      }
    ]
  }
  restart_policy = "Always"
  depends_on = [
    twingate_connector.connector,
    twingate_connector_tokens.tokens
  ]
}

# #######################################################
# ##        GOOGLE COMPUTE TWINGATE VM INSTANCES       ##
# #######################################################


resource "google_compute_instance" "twingate" {
  count = var.twingate_instances_count

  project = var.project_id

  name         = "${var.name}-${var.environment}-twingate-${count.index}"
  machine_type = var.twingate_machine_type

  zone = var.zone_names[0]

  boot_disk {
    initialize_params {
      image = module.container[count.index].source_image
      # image = module.container.source_image
    }

    # kms_key_self_link  = google_kms_crypto_key.disk_encryption_key.id

  }

  can_ip_forward            = false
  allow_stopping_for_update = true

  network_interface {
    # network = var.network_name
    # subnetwork_project = var.project_id
    subnetwork         = var.twingate_subnet_name
    subnetwork_project = var.project_id
    # network_ip         = google_compute_address.internal_with_subnet_and_address[count.index].address
    # access_config {} # This is not required since we do not need a public ip for the twingate instance.
  }



  # tags = var.tags # ["container-vm-example"]

  metadata = {
    gce-container-declaration = module.container[count.index].metadata_value
    # gce-container-declaration = module.container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
    block-project-ssh-keys    = true
  }

  metadata_startup_script = <<SCRIPT
    echo 'net.ipv4.ping_group_range = 0 2147483647' | sudo tee -a /etc/sysctl.d/99-allow-ping.conf
    sudo sysctl -p /etc/sysctl.d/99-allow-ping.conf
    SCRIPT

  # metadata_startup_script = "echo 'net.ipv4.ping_group_range = 0 2147483647' | sudo tee -a /etc/sysctl.conf"

  # labels = merge({ container-vm = module.container[count.index].vm_container_label }, var.labels)

  shielded_instance_config {
    enable_secure_boot = true
  }


  # service_account {
  #   email  = var.service_account_email # google_service_account.compute_admin.email
  #   scopes = ["cloud-platform"]
  # }

  deletion_protection = false # var.deletion_protection

  depends_on = [
    twingate_connector.connector,
    twingate_connector_tokens.tokens
    # google_compute_address.internal_with_subnet_and_address
  ]

  lifecycle {
    replace_triggered_by = [
      null_resource.version
    ]
  }
}

#####################################################################
##        NULL RESOURCE TO TRIGGER TWINGATE CONTAINER UPDATE       ##
#####################################################################

resource "null_resource" "version" {

  # Just to ensure this gets run every time
  triggers = {
    version = var.twingate_image_version
  }
}


resource "twingate_resource" "twingate_resources" {
  name              = "${var.name}-${var.environment}-gke"
  address           = var.private_endpoint_subnetwork_cidr != "" ? var.private_endpoint_subnetwork_cidr : var.master_ipv4_cidr_block
  remote_network_id = twingate_remote_network.network.id # var.twingate_remote_network_id

  # security_policy_id = data.twingate_security_policy.test_policy.id

  protocols = {
    allow_icmp = true
    tcp = {
      policy = "ALLOW_ALL"
      # ports = ["80", "82-83"]
    }
    udp = {
      policy = "ALLOW_ALL"
    }
  }

  dynamic "access_group" {
    for_each = var.twingate_access_group_ids
    content {
      group_id = access_group.value
      # security_policy_id = data.twingate_security_policy.test_policy.id
      # usage_based_autolock_duration_days = 30
    }
  }


  dynamic "access_service" {
    for_each = [twingate_service_account.github_actions.id]
    content {
      service_account_id = access_service.value
    }
  }

  is_active = true

}
