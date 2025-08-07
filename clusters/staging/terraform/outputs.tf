output "namespace" {
  value = kubernetes_namespace.globomantics_staging.metadata[0].name
}

output "app_name" {
  value = kubernetes_deployment.globomantics_app.metadata[0].name
}

output "service_name" {
  value = kubernetes_service.globomantics_service.metadata[0].name
}