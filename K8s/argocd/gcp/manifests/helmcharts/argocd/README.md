# ARGOCD

Below is the reference for ArgoCD helm chart installation.

## REF 

[https://artifacthub.io/packages/helm/argo/argo-cd](https://artifacthub.io/packages/helm/argo/argo-cd)

## APPLY 

```
cd k8s/gcp/argocd/manifests/helmcharts/argocd
kustomize build . --enable-helm | kubectl apply -f -
```