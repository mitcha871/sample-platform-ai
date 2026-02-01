# Sample Platform AI

A showcase of a modern, cloud-native enterprise platform.

## Goal
The goal of this project is to build a "gold standard" reference architecture for a distributed web application. It demonstrates how to scale both technology and teams by implementing strict environment isolation, automated GitOps workflows, and robust observability.

## Architecture Overview

### 1. Application Stack
*   **Frontend:** Modern JS Framework (Next.js/React) hosted on S3 with CloudFront distribution.
*   **Backend:** High-performance Go services (REST/gRPC).
*   **Database:** PostgreSQL (AWS RDS) located in private subnets.
*   **Containerization:** Dockerized services running on Amazon EKS (Kubernetes).

### 2. Infrastructure & Networking
*   **IaC:** Provisioned entirely via **OpenTofu**.
*   **Environment Isolation:** Three distinct environments (`dev`, `uat`, `prod`) isolated at the VPC level.
*   **High Availability:** Multi-region deployment (`ap-southeast-2` and `ap-southeast-4`) to survive regional outages.
    *   **VPC Design:** 2 Availability Zones per region.
    *   **Data Replication:** Aurora Global Database for cross-region PostgreSQL replication; S3 Cross-Region Replication for static assets.
    *   **Traffic Management:** Route 53 Failover routing with health checks for automated regional failover.
    *   **Connectivity:** **AWS Client VPN** for secure, internal-only access to management interfaces (ArgoCD, Grafana).
*   **IAM:** Role-based access control (RBAC) with environment-specific permissions and GitHub OIDC integration.

### 3. Deployment & GitOps
*   **CI (GitHub Actions):** 
    *   Automated testing and linting.
    *   Container image builds pushed to Amazon ECR.
*   **CD (ArgoCD):** 
    *   **GitOps Pattern:** Using the App-of-Apps pattern.
    *   **Cadence:** 
        *   `dev`: Automatic sync on merge.
        *   `uat`: Tag-based promotion.
        *   `prod`: Gated manual approval.

### 4. Observability
*   **Metrics:** Prometheus & Grafana.
*   **Logging:** Loki (storing logs in S3).
*   **Security:** Internal-only Grafana dashboards accessed via VPN.

---

## Directory Structure
```text
/sample-platform-ai
├── /infra                # OpenTofu Infrastructure as Code
│   ├── /modules          # Reusable modules (VPC, EKS, RDS, VPN)
│   └── /environments     # Environment-specific state
│       ├── /dev
│       ├── /uat
│       └── /prod
├── /app                  # Application Source Code
│   ├── /backend          # Go Backend
│   └── /frontend         # JS Frontend
├── /gitops               # Kubernetes Manifests
│   ├── /base             # Shared resources
│   └── /overlays         # Environment-specific patches
└── .github/workflows     # CI/CD Pipelines
```
