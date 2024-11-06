To create, deploy and manage all resources required to run a web app using terraform in GCP.

User inputs are needed for values in dev.tfvars file under environment and GCS bucket path in provider.tf file for setting up the backend for the state file. For now the block is commented out, once the bucket is created it may be uncommmented.