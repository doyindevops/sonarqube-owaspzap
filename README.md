# Infrastructure Provisioning with Terraform on GitHub (GitOps)

This repository contains Terraform configurations and GitHub Actions workflows used to provision and manage AWS infrastructure following GitOps principles. The setup ensures that infrastructure changes are automated, version-controlled, and reliable.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Repository Structure](#repository-structure)
4. [GitHub Actions Workflows](#github-actions-workflows)
5. [Terraform Configuration](#terraform-configuration)
6. [Usage](#usage)
7. [Manual Trigger](#manual-trigger)
8. [Contributing](#contributing)
9. [License](#license)

## Overview

This project leverages Terraform to define and provision infrastructure on AWS. The deployment process is managed by GitHub Actions workflows, which include steps for initialization, validation, security scanning, planning, and applying the changes. This approach ensures that all infrastructure changes are thoroughly tested before being applied.

## Prerequisites

Before you begin, ensure you have the following:

- An AWS account with IAM user credentials (access key and secret key).
- A GitHub repository with the necessary secrets configured for AWS credentials and other environment variables.

## Repository Structure

The repository contains the following main components:

- **`.github/workflows/github-ci.yml`**: GitHub Actions workflow file that automates the CI/CD pipeline for Terraform.
- **`main.tf`**: Main Terraform configuration file.
- **`variables.tf`**: File defining input variables for Terraform.
- **`outputs.tf`**: File defining the outputs of the Terraform configuration.
- **Other Terraform files**: Additional configuration files that define various AWS resources.

## GitHub Actions Workflows

The GitHub Actions workflow (`.github/workflows/github-ci.yml`) automates the entire deployment process, including the following jobs:

1. **Terraform Init**: Initializes Terraform and sets up the backend.
2. **Terraform Validate**: Validates the Terraform configuration to ensure it is syntactically correct.
3. **tfsec Security Scan**: Runs security scans on the Terraform code using `tfsec`.
4. **Terraform Plan**: Creates an execution plan for the changes, showing what will be added, changed, or destroyed.
5. **Terraform Apply**: Applies the changes to the infrastructure. This job can run automatically after a successful plan or be manually triggered.

### Automatic and Manual Deployment

The workflow supports both automatic and manual deployments:

- **Automatic Deployment**: After a successful Terraform plan, the apply job runs automatically to provision the infrastructure.
- **Manual Deployment**: You can manually trigger the apply job using the `workflow_dispatch` event in GitHub Actions.

## Terraform Configuration

### Versions Used in the Project

#### Providers
- hashicorp/aws = 5.3

#### Modules
- terraform-aws-modules/ec2-instance/aws = 5.2.1
- terraform-aws-modules/vpc/aws = 5.1.0

### Resources Created

- Role "app-server-role" with policies:
    - AmazonSSMManagedInstanceCore
    - AmazonEC2ContainerRegistryFullAccess
- Role "gitlab-runner-role" with policies:
    - AmazonSSMFullAccess
    - AmazonEC2ContainerRegistryFullAccess
- VPC "main"
- Security group "main"
- Security group "app-server"
- EC2 server "ec2_app_server" with:
    - Role: app-server-role
    - Security Group: app-server
- EC2 server "ec2_gitlab_runner" with:
    - Role: gitlab-runner-role
    - Security Group: main

**Note**: Both servers use the Ubuntu image: ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*

## Usage

### Create `terraform.tfvars` File

Before running the script, create a `terraform.tfvars` file and set the following variables:

- aws_access_key_id
- aws_secret_access_key
- aws_region
- env_prefix
- runner_registration_token

**Notes**: 
- `variables.tf` declares all variables used in the script and is a normal part of the Terraform script. `terraform.tfvars` assigns values to those declared variables, including secret variables, so it should be created and used locally, not committed to the repository as part of the code.
- Format inside `terraform.tfvars`:
  ```console
  my_var_one="value-one" 
  my_var_two="value-two"

## Terraform Commands ##

# Initialise project & download providers
terraform init 

# Preview what will be created with apply & see if any errors
terraform plan

# Execute with preview
terraform apply -var-file=terraform.tfvars

# Execute without preview
terraform apply -var-file=terraform.tfvars -auto-approve

# Destroy everything
terraform destroy

# Show resources and components from current state
terraform state list




## Terraform Destroy Process Documentation ##
This document provides a step-by-step guide on how to set up and execute the Terraform destroy process using GitHub Actions.

Prerequisites
GitHub Repository: Ensure you have a GitHub repository with your Terraform configuration files.
GitHub Secrets: Store your AWS credentials and necessary environment variables in GitHub Secrets.
Docker: Docker must be installed on the runner machine, whether it is self-hosted or a GitHub-hosted runner.
Steps to Set Up Terraform Destroy Workflow
1. Create a New Workflow File
1.1 Navigate to your GitHub repository and create a new file in the .github/workflows directory named terraform-destroy.yml.

1.2 This workflow will be responsible for initializing and destroying your Terraform-managed infrastructure.

2. Define Environment Variables
2.1 In your workflow file, define the necessary environment variables. These include AWS credentials and any Terraform variables you require.

3. Set Up the Destroy Job
3.1 Create a job within your workflow file that will:

Set up Docker.
Set the appropriate permissions.
Check out the code from your repository.
Initialize Terraform.
Execute terraform destroy to destroy the infrastructure.
4. Triggering the Workflow
4.1 The workflow should be configured to trigger on a push to a specific branch, such as destroy, or manually via the GitHub Actions tab.

5. Execute the Workflow
5.1 Automatic Trigger: Push to the destroy branch in your repository to automatically trigger the destroy workflow.

5.2 Manual Trigger: Navigate to the Actions tab in your GitHub repository, select the Terraform Destroy workflow, and click on the Run workflow button to trigger it manually.

6. Verify Destruction
6.1 Monitor the workflow execution in the GitHub Actions tab to ensure that the destroy process completes successfully.

6.2 Confirm that the Terraform-managed resources have been successfully destroyed in your AWS account.

Example Usage
Pushing to Destroy Branch
Create a new branch named destroy:

sh
Copy code
git checkout -b destroy
Push the destroy branch to your repository:

sh
Copy code
git push origin destroy
Manually Triggering the Workflow
Go to the Actions tab in your GitHub repository.
Select the Terraform Destroy workflow.
Click on the Run workflow button.
By following these steps, you can safely and efficiently destroy your Terraform-managed infrastructure using GitHub Actions.






