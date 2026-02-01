# Observability Module

This module configures the observability stack for the platform, focusing on metrics, logs, and traces.

## Stack
*   **Prometheus:** For metrics collection from EKS nodes and applications.
*   **Grafana:** For visualization and dashboards.
*   **Loki:** For log aggregation (storing logs in S3).

## Access & Security
*   **Internal Access:** Grafana is configured with an internal LoadBalancer, accessible only via the **AWS Client VPN**.
*   **Persistence:** All metrics and logs are persisted to S3 buckets to ensure data is not lost if the cluster is destroyed.
