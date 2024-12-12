resource "tfe_project" "this" {
  organization = var.tf_organization_name
  name         = "${var.prefix}-agents-project-demo"
}

resource "tfe_variable_set" "this" {
  name         = "${var.prefix}-agents-demo-vs"
  description  = "AWS Credentials"
  organization = var.tf_organization_name

}

resource "tfe_project_variable_set" "test" {
  variable_set_id = tfe_variable_set.this.id
  project_id      = tfe_project.this.id
}

resource "tfe_variable" "aws_access_key_id" {
  key             = "AWS_ACCESS_KEY_ID"
  value           = var.aws_access_key_id
  category        = "env"
  variable_set_id = tfe_variable_set.this.id
}

resource "tfe_variable" "aws_secret_access_key" {
  key             = "AWS_SECRET_ACCESS_KEY"
  value           = var.aws_secret_access_key
  category        = "env"
  variable_set_id = tfe_variable_set.this.id
  sensitive       = true
}

resource "tfe_variable" "aws_session_token" {
  key             = "AWS_SESSION_TOKEN"
  value           = var.aws_session_token
  category        = "env"
  variable_set_id = tfe_variable_set.this.id
  sensitive       = true
}
