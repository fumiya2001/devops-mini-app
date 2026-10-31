provider "aws" {
    region = "us-east-1"
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
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

    tags = {
        Name = "devops-mini-app"
    }
}

resource "aws_security_group" "web_sg" {
    name = "web_sg"
    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_iam_role" "ec2_ssm_role"{
    name = "devops-mini-app-ssm-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })

}

resource "aws_iam_role_policy_attachment" "ssm"{
    role = aws_iam_role.ec2_ssm_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
    name = "devops-mini-app-profile"
    role = aws_iam_role.ec2_ssm_role.name
}


output "instance_id" {
    value = aws_instance.web.id
}
output "instance_public_ip" {
    value = aws_instance.web.public_ip
}