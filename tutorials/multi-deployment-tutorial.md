# Terraform Google Cloud Migrate

## Let's get started!

This guide will show you how to deploy the infrastructure required for Migrate using Terraform and Cloud Foundation Toolkit.

**Time to complete**: About 1 hour

Click the **Start** button to move to the next step.

## Cloning the repository

Let's get started by cloning the git repo Migrate Cloud Foundations Toolkit repository inorder to use the provided examples.

```bash
git clone https://github.com/terraform-google-modules/terraform-google-migrate
```

Let's navigate to the cloned repo and into the examples.
We will be using the multi_deployment example in this walkthrough.

```bash
cd terraform-google-migrate/examples/multi_deployment
```

## Assign permissions to the account running this Terraform script

The account running the Terraform script needs these permissions:

- Organization Role Administrator
- Organization Administrator
- Compute Admin
- (Project) Owner

## Exploring the Terraform code and setting variables

The <walkthrough-editor-open-file filePath="terraform-google-migrate/examples/multi_deployment/main.tf" text="main.tf"></walkthrough-editor-open-file> file defines infrastructure that will be created.

The <walkthrough-editor-open-file filePath="terraform-google-migrate/examples/multi_deployment/variables.tf" text="variables.tf"></walkthrough-editor-open-file> file defines variables like billing account, subnet ips etc that will be used.

The <walkthrough-editor-open-file filePath="terraform-google-migrate/examples/multi_deployment/outputs.tf" text="outputs.tf"></walkthrough-editor-open-file> file defines what outputs Terraform will provide us. This includes service account emails that will be used for deploying the Migrate frontend.

Let's create a `terraform.tfvars` and set some of variables necessary to deploy the infrastructure.

```bash
touch terraform.tfvars
```

The following variables needs to be set in the <walkthrough-editor-open-file filePath="terraform-google-migrate/examples/multi_deployment/terraform.tfvars" text="terraform.tfvars"></walkthrough-editor-open-file> file

```terraform
organization_id     = "YOUR ORG ID"
billing_account     = "YOUR BILLING ACCOUNT"
per_folder_admins   = ["user:USER@DOMAIN.com", "group:GROUP@DOMAIN.com"]
all_folder_admins   = ["user:USER@DOMAIN.com", "group:GROUP@DOMAIN.com"]
subnet_01_ip        = "CIDR IP ADDRESS"
subnet_02_ip        = "CIDR IP ADDRESS"
subnet_03_ip        = "CIDR IP ADDRESS"
subnet_01_region    = "REGION FOR SUBNET"
subnet_02_region    = "REGION FOR SUBNET"
subnet_03_region    = "REGION FOR SUBNET"
local_subnet_01_ip  = "CIDR IP ADDRESS"
router_region       = "REGION FOR CLOUD ROUTER"
vpn_region          = "REGION FOR VPN"
```

**Tip**: Clicking on the files will open then in the cloud editor.

Next, we will deploy infrastructure with Terraform

## Deploying infrastructure with Terraform

Let's start by initializing Terraform. This will download the necessary modules and initialize Terraform.

```bash
terraform init
```

Now, we can plan the infrastructure. This will show you the changes Terraform intends to make to the current state for your infrastructure.

```bash
terraform plan --out=plan.out
```

Finally, we can apply the above planned infrastructure to create it in GCP.

```bash
terraform apply "plan.out"
```

## Congratulations

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You’re all set!

Now you can deploy the Migrate frontend from the marketplace.
