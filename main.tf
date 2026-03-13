terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}
provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "iac-lab"
  user_data_replace_on_change = true
  user_data = <<-EOF
    #!/bin/bash
    cd /home/ubuntu
    echo "<h1>Feito com Terraform</h1>" > index.html
    nohup busybox httpd -f -p 8080 &
  EOF
  tags = {
    Name = "learn-terraform"
  }
}
