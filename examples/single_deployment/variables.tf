variable "organization_id" {
  description = "The organization id for the associated services"
}

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
}

variable "credentials_path" {
  description = "Path to a service account credentials file with rights to run the Project Factory. If this file is absent Terraform will fall back to Application Default Credentials."
  default     = "~/.config/gcloud/application_default_credentials.json"
}

variable "all_folder_admins" {
  type        = list(string)
  description = "List of IAM-style members that will get the extended permissions across all the folders."
  default     = []
}

variable "per_folder_admins" {
  type        = list(string)
  description = "List of IAM-style members per folder who will get extended permissions."
  default     = []
}

variable "subnet_01_ip" {
  description = "IP range for the subnet"
}

variable "subnet_02_ip" {
  description = "IP range for the subnet"
}

variable "subnet_03_ip" {
  description = "IP range for the subnet"
}

variable "secondary_s01_range" {
  description = "Secondary IP range for the subnet"
}

variable "secondary_s02_range" {
  description = "Secondary IP range for the subnet"
}

variable "secondary_s03_range" {
  description = "Secondary IP range for the subnet"
}

variable "subnet_01_region" {
  description = "Region of subnet 1"
}

variable "subnet_02_region" {
  description = "Region of subnet 2"
}

variable "subnet_03_region" {
  description = "Region of subnet 3"
}

variable "local_subnet_01_ip" {
  description = "IP range of the on-prem network"
}
