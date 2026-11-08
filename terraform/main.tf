provider "aws" {
    region = var.region
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners      = ["099720109477"] # Canonical

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
}

resource "aws_instance" "web" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    iam_instance_profile = aws_iam_instance_profile.devops-mini-app.name

    #key_name = "aws-service"
    tags = {
        Name = "devops-mini-app"
    }
}

resource "aws_iam_instance_profile" "devops-mini-app" {
  name = "devops-mini-app"
  role = aws_iam_role.role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "devops-mini-app-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "devops-mini-app-attach" {
    role = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_eip" "web_eip"{
    domain = "vpc"
}

resource "aws_eip_association" "web_eip_assoc" {
    instance_id   = aws_instance.web.id
    allocation_id = aws_eip.web_eip.id
}
resource "aws_security_group" "web_sg" {
    name = "web_sg"
    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
#    ingress {
#        from_port = 22
#        to_port = 22
#        protocol = "tcp"
#        cidr_blocks = ["0.0.0.0/0"] # insecure, but for demo purposes
#    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}




output "instance_public_ip" {
    value = aws_instance.web.public_ip
}