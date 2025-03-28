data "aws_subnet" "subnet" {
  id = var.subnet_id
}
locals {
  vpc_id     = data.aws_subnet.subnet.vpc_id
}

# Instance
resource "aws_instance" "ec2" {
  associate_public_ip_address = var.associate_public_ip_address
  ami                  = var.ami
  instance_type        = var.instance_type
  # iam_instance_profile  = var.ec2-iam-role-profile-name
   vpc_security_group_ids = concat(var.sg_ec2_ids, [aws_security_group.ec2_sg_comm.id])
  subnet_id = var.subnet_id
  source_dest_check = !var.isPortForwarding
  # credit_specification {
  #   cpu_credits = "unlimited"
  # }
  # root_block_device {
  #         delete_on_termination = false
  #         encrypted = true
  #         kms_key_id = var.kms_key_id
  #         volume_size = var.ebs_size
  # }
  user_data = var.user_data

  # key_name = "aws-keypair-${var.stage}-${var.servicename}" 

  # tags = merge(tomap({
  #        Name =  "aws-ec2-${var.stage}-${var.servicename}"}),
  #       var.tags)

  tags = {
    Name = "backend_app_instance"
  }
  # lifecycle {
  #   ignore_changes = [user_data,associate_public_ip_address,instance_state]
  # }
}

# instance security group
resource "aws_security_group" "ec2_sg_comm" {
  name        = "webserver_for_arch_sg"
  description = "Allow inbound traffic on port 80 and 443"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    # security_groups = [ aws_security_group.alb_sg.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

# asg
resource "aws_launch_template" "ec2_app_template" {
  image_id      = var.ami
  instance_type = var.instance_type

  user_data = base64encode(var.user_data)

  vpc_security_group_ids = concat(var.sg_ec2_ids, [aws_security_group.ec2_sg_comm.id])
}

resource "aws_autoscaling_group" "ec2_app_asg" {
  vpc_zone_identifier = var.subnet_ids
  desired_capacity    = 2
  min_size            = 2
  max_size            = 3

  launch_template {
    id      = aws_launch_template.ec2_app_template.id
    version = "$Latest"
  }

   target_group_arns = var.target_group_arns

   tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }
}

