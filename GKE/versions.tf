terraform {
  # required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.43"
      # version = "6.8.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.43"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("${path.module}/credentials/creds.json")
  # credentials = file(var.gcp_credentials_file)
  # credentials = "creds.json"
}

provider "google-beta" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("${path.module}/credentials/creds.json")
  # credentials = file(var.gcp_credentials_file)
}

provider "random" {
  # Configuration options
}