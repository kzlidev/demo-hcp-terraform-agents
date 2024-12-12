variable "tf_organization_name" {
  type        = string
  default     = "likz_dev"
  description = "Name of TFE/HCP Terraform Organization"
}

variable "prefix" {
  type        = string
  default     = "likz"
  description = "Prefix to add for all resources created"
}

variable "workspace_count" {
  type        = number
  default     = 3
  description = "Number of workspaces to create"
}

variable "agent_pool_name" {
  type = string
  default = "agent-pool-demo-2"
  description = "Agent pool name. Prefix will be appended infront."
}

variable "vcs_repo_identifier" {
  type        = string
  description = "Identifier of VCS repository in the format <vcs organization>/<repository>"
  default     = "kzlidev/s3-bucket-demo"
}

variable "vcs_oauth_token_id" {
  type      = string
  sensitive = true
}

variable "aws_session_token" {
  type        = string
  description = "AWS_SESSION_TOKEN"
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS_SECRET_ACCESS_KEY"
  sensitive   = true
}

variable "aws_access_key_id" {
  type        = string
  description = "AWS_ACCESS_KEY_ID"
  sensitive   = true
}

variable "k8s_host" {
  type = string
}

variable "client_certificate" {
  type = string
}

variable "client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "tfc_token" {
  type = string
}

variable "tfe_address" {
  type = string
}