# main.tf

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins server"
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0e8a34246278c21e4" # Replace with your desired Jenkins AMI ID
  instance_type = "t2.micro"              # Change as needed
  
  tags = {
    Name = "jenkins-server"
  }


  #security_group = [aws_security_group.jenkins_sg.id]

user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install java-1.8.0 -y
              sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              sudo yum install jenkins -y
              sudo service jenkins start
              EOF
}



# backend.tf


terraform {
  backend "s3" {
    bucket         = "jenkinswk12-bucket"
    key            = "jenkins/terraform.tfstate"
    region         = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-lock"
  }
}

# variables.tf

# You can define variables here if needed

# outputs.tf

# You can define outputs here if needed