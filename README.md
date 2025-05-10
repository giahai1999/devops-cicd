# Sample CICD Application

### Description
I manufacture a CICD pipeline to automate build, test, analyzation and deployment for python application. Whenever there is a push to dev or prod (main) the app would be deployed to AWS EKS cluster. The project integrates Github Action, Docker, Terraform, AWS ECR and AWS EKS (kubernetes)

---

## Technologies & Tools

- **Docker**: Containerize the Python application.
- **AWS ECR**: Act as the Docker image registry.
- **AWS EKS**: To deploy the containerized application in a Kubernetes cluster.
- **Terraform**: Provision EKS and related resources.
- **GitHub Actions**: For CI/CD, include building, testing, security scanning, and deployment.
- **Security Tools**: Trivy, Bandit, and Safety for scanning code and Docker images for vulnerabilities.

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── cicdpipeline.yml
├── kubernetes/
│   ├── deployment.yaml
│   ├── update-k8s-yaml.sh
│   └── service.yaml
├── terraform/
│   ├── main.tf
│   └── variables.tf
├── main.py
├── tests/
│   └── test_healthcheck.py
├── run.sh
└── README.md

---

## Terraform to deploy infrastructure

Terraform Workspaces helps you manage multiple groups of resources with a single configuration.
Two terraform workspaces which are dev and prod will be created. We need to deploy first to the dev , test our APP after deployment, if everything is perfect and fine, then we destroy the resources before finally deploying to prod. because of we want to save resource usage and extra charges it may incure.


---

## CI/CD Pipeline Overview

The CI/CD pipeline executes the following steps:
1. Code Commit
2. Dependency Installation
3. Lint and Unit Test
4. Environment Configuration
5. Build Docker Image
6. Security Scans
7. Push to ECR
8. Update Kubernetes Config
9. Deploy to Kubernetes
10. Health Check

---

## Key Pipeline Stages

1. **Build and Test**: Runs unit tests and linting.
2. **Security Scans**: Uses Bandit, Safety, and Trivy.
3. **Set environment variables**: Checks which branch you’re working on and sets some variables base on the environment
4. **Docker Image Creation**: Builds and pushes the image to ECR.
5. **Deployment**: Deploys to EKS and verifies health.

---

## Kubernetes Configuration

Create a folder named kubernetes , this folder should have three files.

- deployment.yaml: deployes the image we need to our AWS EKS cluster
- service.yaml: exposes our app to the internet using a Loadbalancer
- update-k8s.yaml: helps us to dynamically monitor the ECR and populate the deployment.yaml image with the most recent one if there is any new push or PR in any of the branches.

---

## Secrets for Github Actions

AWS_ACCOUNT_ID
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
ECR_REPOSITORY_DEV
ECR_REPOSITORY_PROD

---

## Branching Strategy

the dev branch will push to the dev branch during deployment but the main branch is modified to be the prod branch within the pipeline. This is to enable the deployment to be seamless and also match with the naming of the terraform workspace deployment.

---

## Known Risks

1. Dependency on AWS: Relies heavily on AWS, limiting portability.
2. Branching Limitations: Only deploys from `dev` and `main` branches.
3. Kubernetes Dependency: Assumes cluster is always healthy.

---

## Project Highlights

- Automated CI/CD workflow with GitHub Actions.
- Use of Terraform for infrastructure provisioning.
- Dockerized Python application with healthcheck endpoint.
- Comprehensive security checks for code and Docker images.
