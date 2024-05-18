#!/bin/bash

# Retrieve the public IP from Terraform output
public_ip=$(terraform output -raw webserver_vm_public_ip)

# Check if the public_ip variable is empty
if [ -z "$public_ip" ]; then
  echo "Error: Failed to retrieve the public IP from Terraform output"
  exit 1
fi

# Output the inventory in JSON format
cat <<EOF
{
  "Web": {
    "hosts": ["example-machine"],
    "vars": {
      "ansible_host": "$public_ip",
      "ansible_user": "adminuser",
      "ansible_ssh_private_key_file": "/home/ifs/.ssh/id_rsa"
    }
  }
}
EOF
