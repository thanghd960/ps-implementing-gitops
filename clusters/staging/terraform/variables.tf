variable "app_image" {
  description = "Application image"
  type        = string
  default     = "nginx:latest"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 2
}