# Security Group for Bastion
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg"
  description = "Allow SSH from anywhere"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-bastion-sg" }
}

# Security Group for Web App EC2
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP from ALB and SSH from Bastion"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-web-sg" }
}

# Bastion Host
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = { Name = "${var.project_name}-bastion" }
}

# Web App EC2 in Private Subnet
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y python3 python3-pip
    pip3 install flask
    cat > /home/ec2-user/app.py << 'PYEOF'
    from flask import Flask
    app = Flask(__name__)

    @app.route('/')
    def home():
        return '<h1>Deployed with Terraform</h1><p>VPC + EC2 + ALB + NAT Gateway</p>'

    if __name__ == '__main__':
        app.run(host='0.0.0.0', port=80)
    PYEOF
    python3 /home/ec2-user/app.py &
  EOF

  tags = { Name = "${var.project_name}-web" }
}
