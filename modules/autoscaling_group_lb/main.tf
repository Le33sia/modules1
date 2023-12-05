# IAM Role for EC2 Instances
resource "aws_iam_role" "ec2_instance_role" {
  name = "EC2InstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Policy to Allow GetSecretValue
resource "aws_iam_policy" "secretsmanager_policy" {
  name        = "SecretsManagerPolicy"
  description = "Policy to allow GetSecretValue from Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["secretsmanager:GetSecretValue"],
        Effect   = "Allow",
        Resource = var.secrets_manager_secret_arn,
      },
    ],
  })
}

# Attach the Inline Policy to the IAM Role
resource "aws_iam_policy_attachment" "secretsmanager_attachment" {
  name       = "SecretsManagerAttachment"
  policy_arn = aws_iam_policy.secretsmanager_policy.arn
  roles      = [aws_iam_role.ec2_instance_role.name]
}

# IAM Role Policy Attachment
resource "aws_iam_instance_profile" "instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_instance_role.name
}

# Here is ami_id that was created with packer
data "aws_ami" "ami" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

# Launch Template
resource "aws_launch_template" "launch_templ" {
  name_prefix   = "launch_templ"
  image_id      = var.image_id
  instance_type = var.instance_type

  # Attach the IAM instance profile to the Launch Template
  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = var.public_snet_1
    security_groups             = [aws_security_group.SGtemplate.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "instance" # Name for the EC2 instances
    }
  }
}

# Auto Scaling Group with Launch Template
resource "aws_autoscaling_group" "ASG" {
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  launch_template {
    id      = aws_launch_template.launch_templ.id
    version = "$Latest"
  }
<<<<<<< HEAD:modules/autoscaling_group_lb/main.tf
  vpc_zone_identifier       = [var.public_snet_1, var.public_snet_2]
=======
  vpc_zone_identifier       = [var.public_subnet1_id]
>>>>>>> 5a414d40ba8b957aa6985f554151a403a9647e3f:modules/ASG/main.tf
  name                      = "ASG"
  health_check_grace_period = 300
  min_elb_capacity          = 0
  health_check_type         = var.health_check_type
  termination_policies      = ["Default"]
  target_group_arns         = [aws_lb_target_group.my_target_group.arn]
  #key_name            = "my_key_name"
}

# Application Load Balancer
resource "aws_lb" "my_alb" {
  name                             = var.lb_name
  internal                         = var.lb_internal
  load_balancer_type               = var.lb_load_balancer_type
<<<<<<< HEAD:modules/autoscaling_group_lb/main.tf
  subnets                          = [var.public_snet_1, var.public_snet_2]
=======
  subnets                          = [var.public_subnet1_id, var.public_subnet2_id]
>>>>>>> 5a414d40ba8b957aa6985f554151a403a9647e3f:modules/ASG/main.tf
  enable_deletion_protection       = var.lb_enable_deletion_protection
  enable_http2                     = true
  enable_cross_zone_load_balancing = true
  security_groups                  = [aws_security_group.ALBSecurityGroup.id]
  tags = {
    Name = "LB"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = var.lb_target_port
  protocol = var.lb_protocol
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}


# LB security group
resource "aws_security_group" "ALBSecurityGroup" {
  name        = "LB-security-group"
  description = "Security group for the Application Load Balancer"

  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
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

# Security group that should be attached to launch template
resource "aws_security_group" "SGtemplate" {
  name        = "SGtemplate"
  description = "Allow incoming HTTP SSH traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    #cidr_blocks = ["0.0.0.0/0"] 
    security_groups = [aws_security_group.ALBSecurityGroup.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
