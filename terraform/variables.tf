variable "namespace" {
  description = "Namespace Kubernetes pour l'application"
  type        = string
  default     = "devops-tp"
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
  default     = "staging"
}