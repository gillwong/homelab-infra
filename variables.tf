variable "pm_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "ci_authorized_sshkey" {
  description = "Authorized public key for SSH access to cloud-init systems"
  type        = string
  sensitive   = true
  nullable    = false
}