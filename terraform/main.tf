#configure AWS provider, have to define IAM role have to select full access

provider "aws" {
  region = "ap-south-1"
}

#define security group

resource "aws_security_group" "ssh"{
  name = "terraform-ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 instance

resource "aws_instance" "example" {
  ami             = "ami-02d26659fd82cf299"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ssh.name]
  key_name = "jenkins-master"

  tags = {
    Name = "ExampleInstance"
  }
}
