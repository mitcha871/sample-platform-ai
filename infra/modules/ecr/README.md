# ECR Module

This module provisions an Amazon Elastic Container Registry (ECR).

## Features
*   **Image Scanning:** Automatically scans images for vulnerabilities on push.
*   **Immutability:** Tag immutability is enabled by default to ensure that once an image is pushed, it cannot be overwritten (crucial for production reliability).
*   **Lifecycle Policy:** Automatically cleans up untagged or old images to manage costs.

## Usage
```hcl
module "ecr_backend" {
  source = "../../modules/ecr"
  name   = "sample-platform/backend"
}
```
