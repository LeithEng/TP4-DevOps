output "namespace_name" {
  description = "Nom du namespace créé"
  value       = kubernetes_namespace.app_namespace.metadata[0].name
}