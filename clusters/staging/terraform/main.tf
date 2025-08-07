terraform {
  required_version = ">= 1.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Create staging namespace
resource "kubernetes_namespace" "globomantics_staging" {
  metadata {
    name = "globomantics-staging"
    labels = {
      environment = "staging"
      managed-by  = "terraform"
      app         = "globomantics"
    }
  }
}

# Create Deployment
resource "kubernetes_deployment" "globomantics_app" {
  metadata {
    name      = "globomantics-app"
    namespace = kubernetes_namespace.globomantics_staging.metadata[0].name
    labels = {
      app = "globomantics-app"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "globomantics-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "globomantics-app"
        }
      }

      spec {
        container {
          name  = "globomantics-app"
          image = var.app_image
          
          port {
            container_port = 80
          }
          
          resources {
            requests = {
              memory = "64Mi"
              cpu    = "50m"
            }
            limits = {
              memory = "128Mi"
              cpu    = "100m"
            }
          }
        }
      }
    }
  }
}

# Create Service
resource "kubernetes_service" "globomantics_service" {
  metadata {
    name      = "globomantics-service"
    namespace = kubernetes_namespace.globomantics_staging.metadata[0].name
  }

  spec {
    selector = {
      app = "globomantics-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}