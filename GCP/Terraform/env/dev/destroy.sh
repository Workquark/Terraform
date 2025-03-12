gcloud config set project concise-mesh-453415-t8
export TF_VAR_project_id=$(gcloud config get project)
export TF_VAR_region="europe-west1"
export TF_VAR_auth_token=$(gcloud auth print-access-token)
terraform destroy -auto-approve