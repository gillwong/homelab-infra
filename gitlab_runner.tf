resource "proxmox_vm_qemu" "gitlab_runner" {
  # VM Template to clone from
  clone  = "almalinux-9-6-x86-64-cloudinit"
  scsihw = "virtio-scsi-single"
  boot   = "order=scsi0"

  # General configuration
  target_node      = "pve2"
  vmid             = 111
  name             = "gitlab-runner"
  agent            = 1
  bios             = "ovmf"
  memory           = 8192
  balloon          = 8192
  vm_state         = "running"
  onboot           = true
  automatic_reboot = true

  # Cloud-Init configuration
  cicustom   = "vendor=local:snippets/dnf_template.yaml"
  ciupgrade  = true
  nameserver = "192.168.0.1"
  ipconfig0  = "ip=192.168.1.129/24,gw=192.168.0.1"
  skip_ipv6  = true
  # almalinux is the default user: https://wiki.almalinux.org/cloud/Generic-cloud-on-local.html#cloud-init
  ciuser  = "almalinux"
  sshkeys = var.ci_authorized_sshkey

  cpu {
    cores = 4
  }

  # Most cloud-init images require a serial device for their display
  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        # We have to specify the disk from our template, else Terraform will think it's not supposed to be there
        disk {
          storage = "local-lvm"
          # The size of the disk should be at least as big as the disk in the template. If it's smaller, the disk will be recreated
          size       = "256G"
          discard    = true
          emulatessd = true
          iothread   = true
        }
      }
    }
    ide {
      # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
      ide1 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
  }

  efidisk {
    efitype = "4m"
    storage = "local-lvm"
  }
}