variable "project_id" {
  type        = string
  default     = "upendra-kumar-440007"
  description = "project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Compute Region"
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
  description = "Compute Zone"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

# variable "gcp_credentials_file" {
#   type = string
# }