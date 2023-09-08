packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

variable "ami_prefix" {
  type    = string
  default = "jenkins-controller-jlipinski"
}

source "amazon-ebs" "jenkins-controller" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t3.medium"
  region        = "eu-central-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

  tags = {
    Name    = "${var.ami_prefix}-${local.timestamp}"
    Owner   = "jlipinski"
    Project = "2023_internship_waw"
  }

  run_tags = {
    Name    = "jenkins-worker-ami-packer-tmp"
    Owner   = "jlipinski"
    Project = "2023_internship_waw"
  }
}

build {
  name = "jenkins-controller"

  sources = [
    "source.amazon-ebs.jenkins-controller"
  ]

  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 2; done",
    ]
  }

  provisioner "shell" {
    script          = "jenkins-init.sh"
    execute_command = "chmod +x {{ .Path }}; sudo {{ .Vars }} {{ .Path }}"
  }
}
