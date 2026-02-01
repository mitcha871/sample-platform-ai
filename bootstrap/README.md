# Bootstrap Layer

This directory contains the "Step 0" infrastructure. Before OpenTofu can manage the platform, it needs a place to store its own state files securely and handle state locking.

## Components
*   **S3 Bucket:** Stores the `.tfstate` files. Encrypted at rest.
*   **DynamoDB Table:** Handles state locking to prevent two people (or two CI jobs) from running Tofu at the same time.

## Initial Setup Instructions (Manual)

Because this is the "chicken and egg" layer, you must run this locally once to create the resources that will hold the state for everything else.

### 1. Prerequisites
*   AWS CLI installed and configured with `AdministratorAccess`.
*   OpenTofu (or Terraform) installed.

### 2. Initialization
```bash
cd bootstrap
tofu init
```

### 3. Deployment
```bash
tofu apply
```
*Note: You will be prompted to confirm. Type `yes`.*

### 4. Post-Setup
Once this is applied, the output will provide the `bucket_name` and `dynamodb_table_name`. These values must be updated in the `providers.tf` files in the `/infra` environments.
