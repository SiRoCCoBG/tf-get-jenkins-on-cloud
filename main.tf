# main.tf
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_token
  region     = var.aws_region
}


#provider "aws" {
# access_key = "ASIAYFSIHWJZUWJSWTPR" ## replace with your access key
# secret_key = "nqilaFknLC5zf4vxkEXqK+tJuUQnwAWRNSncouPR" ## replace with your secret key
#token      = "FwoGZXIvYXdzEMj//////////wEaDOs/+ll2BriHUObcIyK7AQJFt9eLE1wFEpwV/qL1dj8ie90fKkuBIYVHkzaf9VKRViHHjRC7tIJUd2s33/XAq5rcVDSetZK0lsi9OnsoVnQ10D9RTfS/B28+qVS5JJqWIWNj0JNE61KNnxtlUs8ksb50wFuKgkx/5vEMuTkFni+xZWaZhrLo4DuNEWGA6uPM52a6irhXOJbpgFD0VkFMnRv+hY+qrfW37ENMXTCHplSsXZKdV7canztoHyEA1yrq+7NVGu6eO8N7I4Yo/Zj5uAYyLb+mB1jpNqk2d6hNME4hGo5c08COzT7Hqz570gm877i+S/xtsLsFU2bGyC2njw==" ## replace with token 
#region     = "us-east-1"
#}

resource "aws_instance" "project_demo" {
  ami = "ami-04b70fa74e45c3917" # Canonical, Ubuntu, 24.04 LTS, amd64 noble image build on 2024-04-23
  #ami                    = "ami-0e001c9271cf7f3b9" #Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2024-04-11
  #ami                    = "ami-06aa3f7caf3a30282" # Canonical, Ubuntu, 20.04 LTS, amd64 focal image build on 2023-10-25
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.demo.id]


  tags = {
    Name = "project1_demo"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y ansible
              git clone https://github.com/jvsocial/setup-jenkins-on-aws-ubuntu.git
              sudo ansible-playbook setup-jenkins-on-aws-ubuntu/setup-jenkins-ubuntu.yaml
              sudo cat /var/lib/jenkins/secrets/initialAdminPassword > jenkinspass.txt
              EOF
}

resource "aws_security_group" "demo" {
  name        = "demo_sg"
  description = "Demo security group"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}
