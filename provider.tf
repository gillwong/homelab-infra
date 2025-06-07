terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc01"
    }
  }
}

provider "proxmox" {
  pm_api_url  = "https://192.168.0.11:8006/api2/json"
  pm_user     = "terraform-prov@pve"
  pm_password = var.pm_password
}