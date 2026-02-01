# Construction Plan: Sample Platform AI

This document outlines the milestones and sequence for building the platform. Each milestone represents a logical chunk of work with its own documentation and tests.

## Phase 1: The Foundation (Infrastructure)

### ✅ Milestone 1: The Bootstrap
*   **Goal:** Establish remote state management for OpenTofu.
*   **Tasks:** Create S3 bucket for state and DynamoDB for locking.
*   **Status:** COMPLETED.

### ✅ Milestone 2: Networking (VPC)
*   **Goal:** Create isolated, multi-AZ networking for each environment.
*   **Tasks:** 
    *   Build a reusable OpenTofu module for VPCs.
    *   Deploy the `dev`, `uat`, and `prod` environment VPCs in `ap-southeast-2`.
*   **Status:** COMPLETED.

### ✅ Milestone 3: Identity & Security
*   **Goal:** Establish secure access patterns.
*   **Tasks:** 
    *   Set up GitHub Actions OIDC roles (Zero-Trust CI/CD).
    *   Initialize AWS Secrets Manager for the app.
*   **Status:** COMPLETED.

## Phase 2: The Platform (Compute & Data)

### ✅ Milestone 4: The Database (Aurora)
*   **Goal:** Regional and Cross-Region data persistence.
*   **Tasks:** 
    *   Deploy Aurora PostgreSQL (Single-instance for Dev).
    *   Deploy Aurora Global Database for UAT/Prod (Sydney/Melbourne replication).
*   **Status:** COMPLETED.

### ✅ Milestone 5: The Cluster (EKS)
*   **Goal:** Production-grade Kubernetes orchestration.
*   **Tasks:** 
    *   Deploy EKS clusters in private subnets.
    *   Configure Node Groups and OIDC providers for K8s service accounts.
*   **Status:** COMPLETED.

### ✅ Milestone 6: Connectivity (VPN)
*   **Goal:** Secure internal-only access.
*   **Tasks:** Configure AWS Client VPN to allow access to the private subnets.
*   **Status:** COMPLETED.

## Phase 3: The Developer Experience (DX)

### ✅ Milestone 7: The CI/CD Engine
*   **Goal:** Automated build and GitOps flow.
*   **Tasks:** 
    *   Setup ECR registries with cross-region replication.
    *   Install ArgoCD via OpenTofu/Helm.
    *   Configure GitHub Actions workflows.
*   **Status:** COMPLETED.

### ✅ Milestone 8: The Application
*   **Goal:** Deploy the actual software.
*   **Tasks:** 
    *   Build/Deploy Go Backend.
    *   Build/Deploy Next.js Frontend (S3/CloudFront).
    *   **New:** Implement View Counter logic (Backend) and Refresh UI (Frontend).
*   **Status:** COMPLETED.

### ✅ Milestone 9: Observability
*   **Goal:** "Eyes on" the system.
*   **Tasks:** 
    *   Deploy Prometheus/Grafana/Loki.
    *   Configure S3 log shipping for Loki.
*   **Status:** COMPLETED.
