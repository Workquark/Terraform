subnetworks = [
  {
    subnet_name           = "gke-management-cluster-subnet-1"
    subnet_ip             = "10.80.1.0/24"
    subnet_private_access = "true"
    description           = "This is the default gke dev cluster-1 regional subnet in region europe-west1"
    subnet_region         = "europe-west1"

    subnet_flow_logs                 = "false"
    subnet_flow_logs_interval        = "INTERVAL_5_SEC"
    subnet_flow_logs_sampling        = 0
    subnet_flow_logs_metadata        = "INCLUDE_ALL_METADATA"
    subnet_flow_logs_metadata_fields = []
    subnet_flow_logs_filter          = "true"
  },
  {
    subnet_name           = "gke-management-private-endpoint-subnet-1"
    subnet_ip             = "10.80.21.0/28"
    subnet_private_access = "true"
    description           = "This is the default gke private endpoint subnet in region europe-west1"
    subnet_region         = "europe-west1"

    subnet_flow_logs                 = "false"
    subnet_flow_logs_interval        = "INTERVAL_5_SEC"
    subnet_flow_logs_sampling        = 0
    subnet_flow_logs_metadata        = "INCLUDE_ALL_METADATA"
    subnet_flow_logs_metadata_fields = []
    subnet_flow_logs_filter          = "true"
  },
  {
    subnet_name           = "ops-management-subnet-1"
    subnet_ip             = "10.80.21.240/28"
    subnet_private_access = "true"
    description           = "This is the default operations/devops resources regional subnet in region europe-west1"
    subnet_region         = "europe-west1"

    subnet_flow_logs                 = "false"
    subnet_flow_logs_interval        = "INTERVAL_5_SEC"
    subnet_flow_logs_sampling        = 0
    subnet_flow_logs_metadata        = "INCLUDE_ALL_METADATA"
    subnet_flow_logs_metadata_fields = []
    subnet_flow_logs_filter          = "true"
  },
]

subnetwork_secondary_ranges = {
  "gke-management-cluster-subnet-1" = [
    {
      range_name    = "gke-management-cluster-service-subnet-1"
      ip_cidr_range = "10.80.11.0/24"
    },
    {
      range_name    = "gke-management-cluster-pod-subnet-1"
      ip_cidr_range = "10.81.0.0/16"
    }
  ]
}