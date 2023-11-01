provider "aws" {
  region = "us-east-1"
  alias  = "east"
}

provider "aws" {
  region = "us-west-1"
  alias  = "west"
}

resource "aws_security_group" "ssm_access_east" {
  provider    = aws.east
  name_prefix = "ssm-access-east-"
  description = "Allow SSH and ICMP access from SSM in us-east-1"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssm-access-east"
  }
}

resource "aws_security_group" "ssm_access_west" {
  provider    = aws.west
  name_prefix = "ssm-access-west-"
  description = "Allow SSH and ICMP access from SSM in us-west-1"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssm-access-west"
  }
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "ec2-ssm-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_instance" "instance_east" {
  provider           = aws.east
  ami                = "ami-01bc990364452ab3e"
  instance_type      = "t2.micro"
  security_groups    = [aws_security_group.ssm_access_east.name]
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_instance_profile.name

  tags = {
    Name = "EC2 Instance us-east-1"
  }
}

resource "aws_instance" "instance_west" {
  provider           = aws.west
  ami                = "ami-070c8ca4ac77fae0b"
  instance_type      = "t2.micro"
  security_groups    = [aws_security_group.ssm_access_west.name]
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_instance_profile.name

  tags = {
    Name = "EC2 Instance us-west-1"
  }
}
