# GCP 

Below are the steps to install GCP GKE




### Set GCP project

```
gcloud config set project <project name>
```

You'd have to do this in all of 

- plan.sh
- apply.sh
- destroy.sh

### Set GCP region

```bash
TF_VAR_region = <gcp region name>
```

You'd have to do this in all of 

- plan.sh
- apply.sh
- destroy.sh


## GKE PROVISIONING

```bash
cd Terraform/GCP/env/dev
./plan.sh
./apply.sh
```

### 🔧 Terraform Plan

Execute the bash plan.sh to execute and see the plan for the application.

```bash
./plan.sh
```

### 🚀 Terraform Apply

```bash
./apply.sh
```

## PROVISION ARGOCD

```bash
cd k8s/argocd/gcp/manifests/helmcharts/argocd

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm upgrade -i --wait argocd argo/argo-cd --version 7.8.13 -n argocd --create-namespace -f argocd.values.yaml
```

