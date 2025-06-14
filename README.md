# Homelab Infrastructure

This repository manages a homelab environment using Terraform/OpenTofu to provision and configure virtual machines on a Proxmox cluster.

## Overview

- Proxmox Provider: Uses the `telmate/proxmox` provider to interact with the Proxmox API.
- VMs Managed:
  - Kubernetes control plane nodes (`k8s_cp.tf`)
  - Kubernetes worker nodes (`k8s_worker.tf`)
  - Self-hosted GitLab Runners (`gitlab_runner.tf`).
- Base Image: All VMs are cloned from an AlmaLinux 9 cloud-init template.
- Cloud-Init: Automated configuration of users, SSH keys, and networking.

## Setup Proxmox

1. Install Proxmox VE by following the [official guide](https://www.proxmox.com/en/products/proxmox-virtual-environment/get-started).
2. Create a user for the OpenTofu Proxmox provider as described in the [provider documentation](https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md).
3. Create a Proxmox VE VM template using the [cloud-init getting started guide](https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/guides/cloud-init%20getting%20started.md).
4. Download AlmaLinux 9 [cloud-init images](https://wiki.almalinux.org/cloud/Generic-cloud.html) and use them as the base image for your VM templates. This homelab uses AlmaLinux OS 9 (RHEL-compatible) and template IDs in the 90x range by default. Create one VM template per Proxmox node.
5. Review and adjust the OpenTofu files as needed (e.g., Proxmox API URL, VM network/disk settings).
6. Optionally, create an `.auto.tfvars` file to store [variable values](https://opentofu.org/docs/language/values/variables/#variable-definitions-tfvars-files).

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in required secrets (e.g., Proxmox password, SSH key).
2. Initialize and apply the configuration:
   ```sh
   tofu init
   tofu apply
   ```

## Variables

- `pm_password`: Proxmox API password (required, sensitive)
- `ci_authorized_sshkey`: Authorized SSH public keys for VM access (required, sensitive)

## Notes

- Ensure your Proxmox user has API access and permissions to create/manage VMs.
- The configuration is modular; you can adjust VM specs and counts as needed.
