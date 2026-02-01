# Deployment Guide: Sample Platform AI

This guide provides the sequence of commands and manual steps required to deploy the platform from scratch.

## Prerequisites
1.  **AWS Account:** With Administrator permissions.
2.  **Tools Installed:** `opentofu` (or `terraform`), `kubectl`, `aws-cli`, `docker`.
3.  **GitHub Repo:** A fork or clone of this repository.

---

## Step 1: Bootstrap Infrastructure
The bootstrap layer creates the S3 bucket and DynamoDB table for OpenTofu state management.

1.  Navigate to `bootstrap/`.
2.  Initialize and apply:
    ```bash
    tofu init
    tofu apply
    ```
3.  **Note:** After the first apply, you may want to update the `backend` block in `infra/environments/*/providers.tf` to point to the newly created bucket name.

---

## Step 2: GitHub Environment Setup (Manual)
To enable the CI/CD gated flow, you must create environments in your GitHub repository:

1.  GitHub Repo > **Settings** > **Environments**.
2.  Create `dev` (No protection).
3.  Create `uat`. Check **Required reviewers** and add yourself.
4.  Create `prod`. Check **Required reviewers** and add yourself.

---

## Step 3: GitHub OIDC Identity
1.  Navigate to `infra/environments/dev/`.
2.  Ensure you have defined your GitHub repo name in the OIDC module variables.
3.  Apply: `tofu apply`.
4.  Capture the `github_actions_role_arn` output. Add it as a Secret named `AWS_ROLE_ARN` in GitHub (**Settings** > **Secrets and variables** > **Actions**).

---

## Step 4: Networking & Database
Apply the networking and database layers for each environment.
```bash
cd infra/environments/dev
tofu apply
```
*Repeat for `uat` and `prod` once ready.*

---

## Step 5: Kubernetes Cluster (EKS)
1.  Apply the EKS manifests in `infra/environments/dev/eks.tf`.
2.  Update your local kubeconfig:
    ```bash
    aws eks update-kubeconfig --region ap-southeast-2 --name dev-eks
    ```

---

## Step 6: Application Deployment (GitOps)
The CI/CD pipeline handles the Docker builds.
1.  Push a change to `main`.
2.  Wait for the "Platform CI/CD" workflow to finish the `test` and `deploy-dev` jobs.
3.  For UAT/Prod, go to the **Actions** tab and click **Review deployments** to approve the promotion.

---

## Step 7: Post-Deployment DB Setup (IAM)
Since we are using IAM authentication, you must manually create the database user once after the Aurora cluster is up:

1.  Connect to your DB (via VPN or bastion):
    ```sql
    CREATE USER iam_user;
    GRANT rds_iam TO iam_user;
    GRANT ALL PRIVILEGES ON DATABASE postgres TO iam_user;
    ```
2.  The Go backend will handle table creation on its first successful connection.
