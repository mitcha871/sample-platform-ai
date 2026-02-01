# Sample Platform AI

A showcase of a modern, cloud-native enterprise platform.

## Goal
The goal of this project is to build a "gold standard" reference architecture for a distributed web application. It demonstrates how to scale both technology and teams by implementing strict environment isolation, automated GitOps workflows, and multi-region high availability.

## Architecture Strategy: Environment Tiers

To balance cost, learning, and reliability, we use a tiered approach for our environments:

| Feature | Dev (Sandbox) | UAT (Mirror) | Prod (Live) |
| :--- | :--- | :--- | :--- |
| **Regions** | 1 (ap-southeast-2) | 2 (ap-southeast-2/4) | 2 (ap-southeast-2/4) |
| **Availability** | Single AZ | Regional Failover | Regional + AZ Failover |
| **Database** | Single Instance RDS | Global Aurora (Small) | Global Aurora (Large) |
| **CI/CD** | Auto-deploy on merge | Manual Trigger | Gated Manual Approval |
| **Routing** | Simple DNS | Latency-based | Latency + Health Checks |

## Core Pillars

### 1. Application Stack
*   **Frontend:** Next.js/React hosted on S3 + CloudFront.
*   **Backend:** Go (REST/gRPC) containerized with Docker.
*   **Database:** PostgreSQL via Amazon Aurora Global Database for cross-region replication.
*   **Orchestration:** Amazon EKS (Kubernetes) with worker nodes in private subnets.

### 2. Infrastructure & Networking
*   **IaC:** Provisioned via **OpenTofu** with a `bootstrap` layer for state management.
*   **Networking:** Isolated VPCs per environment.
*   **Global Traffic:** Route 53 Latency-based routing to direct Sydney/Melbourne users to the nearest healthy region.
*   **Security:** 
    *   **AWS Client VPN** for internal access to management tools.
    *   **AWS Secrets Manager** for sensitive credentials (no plain-text secrets).
    *   **IAM OIDC** for secure GitHub Actions integration.

### 3. Deployment & GitOps
*   **Container Registry:** Amazon ECR with cross-region image replication.
*   **CD (ArgoCD):** Implements the GitOps pattern using the App-of-Apps structure.
*   **Observability:** 
    *   **Prometheus & Grafana:** Metrics (internal access only).
    *   **Loki:** Centralized logging with S3 persistence.

---

## Directory Structure
```text
/sample-platform-ai
├── /bootstrap            # Initial S3/DynamoDB for Tofu state
├── /infra                # OpenTofu Infrastructure
│   ├── /modules          # Reusable modules (VPC, EKS, Aurora, VPN)
│   └── /environments     # Live state (dev, uat, prod)
├── /app                  # Application Source Code
│   ├── /backend          # Go Backend
│   └── /frontend         # JS Frontend
├── /gitops               # Kubernetes Manifests (ArgoCD)
│   ├── /base             # Standard resources
│   └── /overlays         # Env patches (replicas, ingress)
└── .github/workflows     # CI/CD Pipelines
```
