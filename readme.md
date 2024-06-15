# Azure Web Server with Public IP - Terraform Configuration

This document describes the Terraform configuration for deploying a web server environment on Microsoft Azure. The environment includes:

- Resource Group
- Virtual Network with Subnet
- Public IP Address
- Network Interface Card (NIC)
- Linux Virtual Machine (VM)

## Requirements

- Terraform installed and configured with the Azure provider: [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

## Usage

1. **Save the Script**: Save the Terraform code as a `.tf` file (e.g., `webserver.tf`).

2. **Configure Azure Credentials**:

    Set up Azure credentials for Terraform to interact with your subscription. Refer to the official Terraform documentation for details on [Azure provider authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret).

3. **Run Terraform**:

    - Open a terminal and navigate to the directory containing the `.tf` file.
    - Initialize Terraform: `terraform init`
    - Review the execution plan: `terraform plan`
    - Apply the configuration (if satisfied with the plan): `terraform apply`

## Output

After a successful run, use the following command to retrieve the public IP address of the web server VM:

```bash
terraform output webserver_vm_public_ip
