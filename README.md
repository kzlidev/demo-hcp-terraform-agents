# Terraform Kubernetes Operator

Note: This tutorial assumes that you have already configured VCS integration within your TFE/HCP Terraform Organization 

## Get TFE/HCP Terraform Token
- Create a team token with `Manage all projects` permission
- https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-operator-v2#configure-hcp-terraform-access 

## Setup Environment

1. Deploy Kubernetes Cluster (optional)
```bash
brew install kind
kind create cluster --name terraform-learn
```

2. Generate the `.tfvars` file 
```bash
kubectl config view --minify --flatten --context=kind-terraform-learn -o go-template-file=tfvars.gotemplate > terraform.tfvars
```
One the tf `.tfvars` file is created, you'll need to populate the rest of the variables 
```bash
k8s_host               = <generated_by_previous_step>
client_certificate     = <generated_by_previous_step>
client_key             = <generated_by_previous_step>
cluster_ca_certificate = <generated_by_previous_step>
aws_access_key_id      = <AWS_ACCESS_KEY_ID>
aws_secret_access_key  = <AWS_SECRET_ACCESS_KEY>
aws_session_token      = <AWS_SESSION_TOKEN>
tfc_token              = <TFE/HCP Terraform Team token> 
tfe_address            = ""
vcs_oauth_token_id     = <TFE/HCP Terraform VCS Oauth Token ID>
```

3. Run Terraform to create agents and Terraform resources
```bash
terraform init
terraform apply --auto-approve
```


Teardown 
```bash
kind delete cluster --name terraform-learn
```
This repo takes reference from the [Deploy Infrastructure with the HCP Terraform Operator for Kubernetes v2](https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-operator-v2) tutorial.
