## Getting Started

#### Configuring Migrate for Compute Engine Landing Zone with CFT

### Tools

**Install Cloud SDK** \
The Google Cloud SDK is used to interact with your GCP resources. [Installation instructions](https://cloud.google.com/sdk/downloads) for

multiple platforms are available online.

**Install Terraform** \
Terraform is used to automate the manipulation of cloud infrastructure. Its [installation instructions](https://www.terraform.io/intro/getting-started/install.html) are also available online.

**Authenticate gcloud** \
Prior to running this, ensure you have authenticated your gcloud client by running the following command:

```
gcloud auth application-default login
```

### Deployment

Download the repository:

```
git clone https://github.com/terraform-google-modules/terraform-google-migrate.git
```

File structure

The project has the following folders and files:

```

/: root folder
/examples: Examples for doing single and multi project deployments
/modules: Modules for core, single and multi projects
/helpers: Optional helper scripts for ease of use
/main.tf: TODO
/variables.tf:TODO
/output.tf: TODO
/readme.md: this file

```

**Single project deployment:**

We will start with deploying our **single** project:

```
cd examples/single_deployment
```

Provide this variables in terraform.tfvars:

```
organization_id = "GCP ORGANIZATION ID"
billing_account = "GCP BILLING ID"
credentials_path = "SA KEY USED TO PROVISION RESOURCES"
subnet_01_ip = "GCP VPC SUBNET IP"
subnet_02_ip = "GCP VPC SUBNET IP"
subnet_03_ip = "GCP VPC SUBNET IP"
subnet_01_region = "GCP VPC REGION"
subnet_02_region = "GCP VPC REGION"
subnet_03_region = "GCP VPC REGION"
local_subnet_01_ip = "ON-PREM/OTHER CLOUD SUBNET"
```

Initialize, plan and deploy:

```
terraform init
tf plan -var-file="terraform.tfvars"
tf apply -var-file="terraform.tfvars"
```

The service accounts and project names required for completing the deployment will be generated as terraform output.

Once complete continue with [deploying](https://cloud.google.com/migrate/compute-engine/docs/4.5/how-to/configure-manager/configuring-on-gcp) Migrate for Compute Engine Manager via GCP [Marketplace](https://console.cloud.google.com/marketplace/details/click-to-deploy-images/velostrata?_ga=2.230596124.-1830265044.1554384916&_gac=1.75634663.1564563946.CL6bne_m3uMCFYYkGwodLkkPoQ) and Migrate for Compute Engine [backend](https://cloud.google.com/migrate/compute-engine/docs/4.5/how-to/configure-manager/configuring-vms-vm) or [prerequisites](https://cloud.google.com/migrate/compute-engine/docs/4.5/how-to/migrate-aws-to-gcp/overview) for AWS if migrating from AWS, and [prerequisites](https://cloud.google.com/migrate/compute-engine/docs/4.5/how-to/migrate-azure-to-gcp/azure-prerequisites) for Microsoft.

**Multi project deployment:**

```
cd ..
cd examples/multi_deployment
```

Provide this variables in terraform.tfvars:

```
organization_id = "GCP ORGANIZATION ID"
billing_account = "GCP BILLING ID"
credentials_path = "SA KEY USED TO PROVISION RESOURCES"
subnet_01_ip = "GCP VPC SUBNET IP"
subnet_02_ip = "GCP VPC SUBNET IP"
subnet_03_ip = "GCP VPC SUBNET IP"
subnet_01_region = "GCP VPC REGION"
subnet_02_region = "GCP VPC REGION"
subnet_03_region = "GCP VPC REGION"
local_subnet_01_ip = "ON-PREM/OTHER CLOUD SUBNET"
```

The service accounts and project names required for completing the deployment will be generated as terraform output.

Once complete continue with [deploying](https://cloud.google.com/migrate/compute-engine/docs/4.5/how-to/configure-manager/configuring-on-gcp) Migrate for Compute Engine Manager via GCP [Marketplace](https://console.cloud.google.com/marketplace/details/click-to-deploy-images/velostrata?_ga=2.230596124.-1830265044.1554384916&_gac=1.75634663.1564563946.CL6bne_m3uMCFYYkGwodLkkPoQ) and Migrate for Compute Engine [backend](https://cloud.google.com/migrate/compute-engine/docs/4.5/how-to/configure-manager/configuring-vms-vm) or [prerequisites](https://cloud.google.com/migrate/compute-engine/docs/4.5/how-to/migrate-aws-to-gcp/overview) for AWS if migrating from AWS, and [prerequisites](https://cloud.google.com/migrate/compute-engine/docs/4.5/how-to/migrate-azure-to-gcp/azure-prerequisites) for Microsoft Azure.
