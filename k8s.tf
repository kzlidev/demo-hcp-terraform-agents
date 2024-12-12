// Create namespace for Operator
resource "kubernetes_namespace" "tfc-operator-system" {
  metadata {
    name = "tfc-operator-system"
  }
}

// Create namespace for application
resource "kubernetes_namespace" "tfagent" {
  metadata {
    name = "${var.prefix}-tfagent"
  }
}

// Create terraformrc secret for Operator
resource "kubernetes_secret" "terraformrc" {
  metadata {
    name      = "terraformrc"
    namespace = kubernetes_namespace.tfagent.metadata[0].name
  }

  data = {
    "token" = var.tfc_token
  }
}

// Terraform Cloud Operator for Kubernetes helm chart
resource "helm_release" "operator" {
  name       = "terraform-operator"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "hcp-terraform-operator"
  version    = "2.6.0"

  namespace        = kubernetes_namespace.tfc-operator-system.metadata[0].name
  create_namespace = true

  set {
    name  = "operator.watchedNamespaces"
    value = "{${kubernetes_namespace.tfagent.metadata[0].name}}"
  }

  /* Uncomment to deploy to Terraform Enterprise
  set {
    name  = "operator.tfeAddress"
    value = var.tfe_address
  }
  */
}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [helm_release.operator]

  lifecycle {
    replace_triggered_by = [
      null_resource.always_run
    ]
  }

  create_duration = "10s"
}

resource "null_resource" "always_run" {
  triggers = {
    timestamp = timestamp()
  }
}

resource "kubectl_manifest" "agent_pool" {
  depends_on = [helm_release.operator, time_sleep.wait_10_seconds]
  lifecycle {
    replace_triggered_by = [
      null_resource.always_run
    ]
  }
  override_namespace = kubernetes_namespace.tfagent.metadata[0].name

  yaml_body = <<YAML
apiVersion: app.terraform.io/v1alpha2
kind: AgentPool
metadata:
  name: ${var.prefix}-${var.agent_pool_name}
spec:
  organization: likz_dev
  token:
    secretKeyRef:
      name: terraformrc
      key: token
  name: ${var.prefix}-${var.agent_pool_name}
  agentTokens:
    - name: ${var.prefix}-${var.agent_pool_name}-token
  agentDeployment:
    replicas: 2
    spec:
      containers:
        - name: tfc-agent
          image: "hashicorp/tfc-agent:1.13.1"
  autoscaling:
    minReplicas: 1
    maxReplicas: 3
    cooldownPeriod:
       scaleUpSeconds: 5
       scaleDownSeconds: 30
YAML
}