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

# CONFIGURE OPEN ID 

[https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions)

```bash
PROJECT=$(gcloud config get project )
PROJECT_ID=$(gcloud projects describe $PROJECT --format="value(projectNumber)")
REPO="Workquark/Terraform"
WORKLOAD_IDENTITY_POOL_ID="github"

gcloud iam workload-identity-pools create "github" \
  --project=$PROJECT_ID \
  --location="global" \
  --display-name="github identity pool"


gcloud iam workload-identity-pools providers create-oidc "github-provider" \
  --project=$PROJECT_ID \
  --location="global" \
  --workload-identity-pool="github" \
  --display-name="github action provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.aud=assertion.aud" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-condition="assertion.repository_owner == 'defyjoy'"


gcloud iam service-accounts add-iam-policy-binding "github@$PROJECT.iam.gserviceaccount.com" \
  --project=$PROJECT \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_ID}/locations/global/workloadIdentityPools/github/attribute.repository/${REPO}"


 gcloud iam roles create DnsCustomPolicy \
  --title="DNS Custom Policy" \
  --description="This role Allows you to set IAM policy for DNS Managed Zones" \
  --permissions="dns.managedZones.setIamPolicy" \
  --project=$PROJECT
```