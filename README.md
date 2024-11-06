# Kubernetes TodoList Web Application

This project deploys a **TodoList web application** consisting of **frontend, backend, and PostgreSQL database** components, all containerized and managed with Kubernetes on **Google Cloud Platform (GCP)**.

## Project Structure

The project is organized as follows:

- **GKE/**: Contains Terraform code for provisioning GKE infrastructure.
- **k8s-gcp/**: Includes Kubernetes YAML manifests for deploying the app on GCP.
- **Application/**: Holds source code for the backend, frontend, and scripts for Docker image builds and deployments.
- **.github/workflows**: Holds the source code yaml for Github Actions Workflow for CI integration.

### Folder Breakdown

```
.
├── Application
│   ├── backend                  # Backend source code
│   ├── frontend                 # Frontend source code
│   ├── build_and_push_docker_cr.sh  # Script for Docker image build and push
│   ├── k8s-gcp                  # GCP-specific Kubernetes YAML manifests
│   ├── k8s-gcp-chart            # GCP-specific Kubernetes YAML helm charts
├── GKE
│    ├── modules                  # Reusable Terraform modules
│    ├───environment
│    │   ├── dev                      # Development environment configuration
│    │   ├── prod                     # Production environment configuration
│    │   └── stage                    # Staging environment configuration
│    ├── main.tf                  # Main Terraform configuration for GKE
│    ├── outputs.tf               # Output variables for infrastructure
│    ├── providers.tf             # Cloud provider configuration
│    ├── variables.tf             # Variable definitions for configuration

```

## Deployment Steps

1. **Infrastructure Provisioning**: Use Terraform scripts in the `GKE/` folder to create and configure Google Kubernetes Engine (GKE) clusters.
  
2. **Application Deployment**: Kubernetes manifests in `k8s-gcp/` configure and deploy the frontend, backend, and database services on GKE. Also have helm charts to use under k8s-gcp-chart folder
    helm install gcpwebapp k8s-gcp-chart
    helm upgrade gcpwebapp k8s-gcp-chart
    helm uninstall gcpwebapp

3. **CI/CD Pipeline**: Run the GitHub Actions workflow located in `.github/workflows/ci.yaml` to automate the provisioning and deployment processes.

## Key Features

- **Scalability**: Configured Horizontal Pod Autoscalers for dynamic scaling based on CPU usage.
- **Security**: Encrypted sensitive information and restricted network access.
- **Service Discovery**: Kubernetes services for internal communication between app components.
- **Automation**: Terraform and Kubernetes manifests manage infrastructure as code.
  

## Requirements
- **Google Cloud Platform (GCP)**: A GCP project with necessary permissions.
- **Terraform**: Install Terraform for GKE provisioning.
- **Docker**: For container image builds and local testing.

For further information, refer to individual folder `README.md` files for helpful commands and setup details. 



- **Scalability**:
   - *HorizontalPodAutoscaler* is set up on the frontend, backend with realistic min/max replicas.
   - *Resource Requests and Limits*: CPU and memory requests and limits are appropriate for the current traffic load and scale up smoothly.
   - *Load Balancer Configurations*: load balancers can handle incoming traffic and distribute it effectively among pods.

- **Automation**:
   - *Continuous Deployment*:  GitHub Actions workflows to ensure supporting efficient, repeatable deployments.
   - *Infrastructure as Code (IaC)*: All GCP resources are provisioned with Terraform, minimizing manual changes in the GCP console.

- **Service Discovery**:
    - *Internal Service Discovery*: Kubernetes services can discover each other through ClusterIP configurations.
    - *External DNS*: If external DNS is available, the ExternalDNS controller can be  configured to automatically create DNS entries.

- **Security**:
    - *Secrets Management*: Ensuring the secrets are not exposed anywhere in the code, sensitive information handled appropriately.
    - *Network Policies*: NetworkPolicy configurations restrict internal communications between services (e.g., frontend can’t access the database directly).
    - *IAM Roles and Permissions*: Kubernetes service accounts have minimal IAM permissions to only required resources.
    - *Network Policy for Database*: Used a NetworkPolicy to limit access to database service (restricting it to the backend pods only). This way, only the necessary pods can communicate with the database, reducing unauthorized access.
    - *SSL/TLS*: For secure backend and frontend communication through the load balancer with HTTPS, using managed certificates. This is not enabled ta the moment. 
    
    - If a domain name is available:
        1. Create a ManagedCertificate resource for domain.
        2. Update the Service manifest for backend to specify HTTPS.
        3. Optionally configure Ingress for both frontend and backend with SSL support.
        4. Update application code or backend URLs as necessary to ensure HTTPS-only communication.

- **High Availability & Resilience**:
    - *Multi-Zone Deployment*:  GKE cluster configured to run across multiple zones, and  node pools set with high-availability zones.
    - *Pod Disruption Budgets (PDB)*: enabled PDB for backend pods to maintain a minimum number of pods during updates.
    - *Liveness and Readiness Probes*: Ensuring all pods have properly configured health checks to automatically restart unhealthy pods and prevent traffic from reaching unready instances.

    - Below are example configurations for the **backend** and **PostgreSQL database** liveness and readiness probes.

    ### Backend Service

        ```yaml
        # Backend Liveness and Readiness Probes
        containers:
        - name: backend
            image: your-backend-image

            # Define the liveness probe
            livenessProbe:
            httpGet:
                path: /healthz           # Customize to match app's health endpoint
                port: 80
            initialDelaySeconds: 15    # Time to wait before starting to check
            periodSeconds: 20          # How often to perform the check
            failureThreshold: 3        # Restart pod after 3 consecutive failures

            # Define the readiness probe
            readinessProbe:
            httpGet:
                path: /readyz            # Customize to match app's readiness endpoint
                port: 80
            initialDelaySeconds: 5
            periodSeconds: 10          # How often to perform the check
            failureThreshold: 3        # Mark as unready after 3 consecutive failures
        ```
    ### postgres service
        ```yaml
        # PostgreSQL Liveness and Readiness Probes
            containers:
            - name: postgres
                image: postgres:15

                # Define the liveness probe
                livenessProbe:
                exec:
                    command:
                    - pg_isready
                    - -U
                    - postgres
                initialDelaySeconds: 30
                periodSeconds: 60

                # Define the readiness probe
                readinessProbe:
                exec:
                    command:
                    - pg_isready
                    - -U
                    - postgres
                initialDelaySeconds: 10
                periodSeconds: 30
        ```

PS: Monitoring and logging solution not integrated yet.
