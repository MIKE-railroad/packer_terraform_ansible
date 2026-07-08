packer {
  required_version = ">= 1.11.0"

  required_plugins {
    hyperv = {
      source  = "github.com/hashicorp/hyperv"
      version = ">= 1.1.0"
    }

    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.1"
    }
  }
}

#########################
# Variables
#########################

variable "vm_name" {
  type    = string
  default = "Rocky10-Template"
}

variable "iso_path" {
  type    = string
  default = "C:/MyLab/ISO/Rocky-10.1-x86_64-minimal.iso"
}

variable "switch_name" {
  type    = string
  default = "MyLab_Networking"
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

variable "ssh_password" {
  type    = string
  sensitive = true
  default = "packer"
}

#########################
# Builder
#########################

source "hyperv-iso" "rocky10" {

  vm_name = var.vm_name

  generation = 2

  switch_name = var.switch_name

  communicator = "ssh"

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password

  ssh_timeout = "45m"

  cpus = 2

  memory = 4096

  disk_size = 40960

  enable_secure_boot = false

  iso_url = var.iso_path

  iso_checksum = "none"

  http_directory = "C:/MyLab/packer_terraform_ansible/packer/http/"

  shutdown_command = "echo '${var.ssh_password}' | sudo -S shutdown -P now"

  boot_wait = "5s"

  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg",
    "<f10>"
  ]
}

#########################
# Build
#########################

build {

  sources = [
    "source.hyperv-iso.rocky10"
  ]

  provisioner "shell" {

    inline = [
      "echo 'Provisioning Started'",
      "sudo dnf -y update",
      "sudo dnf clean all"
    ]

  }

  #
  # Uncomment later
  #
  # provisioner "ansible" {
  #
  #   playbook_file = "./ansible/playbook.yml"
  #
  # }

}
