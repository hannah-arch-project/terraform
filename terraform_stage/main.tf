terraform {
 required_version = ">= 1.0.0, < 2.0.0"

#   backend "s3" {
#     bucket = "sdahye-terraformstate"
#     key  = "stage/terraform/terraform.tfstate"
#     region = "ap-northeast-2"
#     encrypt = true
#     dynamodb_table = "sdahye-terraform-state"
#   }
}

module "vpc" {
    source = "../modules/vpc"

    # stage       = var.stage
    # servicename = var.servicename
    # tags        = var.tags
    ## region     = var.region
    ## kms_arn = var.s3_kms_key_id

    vpc_ip_range = var.vpc_ip_range
    az           = var.az

    subnet_public_az1 = var.subnet_public_az1
    subnet_public_az2 = var.subnet_public_az2
    subnet_app_az1 = var.subnet_app_az1
    subnet_app_az2 = var.subnet_app_az2
    subnet_db_az1  = var.subnet_db_az1
    subnet_db_az2  = var.subnet_db_az2
}

module "alb" {
    source = "../modules/alb"

    vpc_id = module.vpc.vpc_id
    sg_allow_comm_list = [var.subnet_public_az1, var.subnet_public_az2]
    subnet_ids = module.vpc.public_app_subnet_ids
    certificate_arn = "arn:aws:acm:ap-northeast-2:405894838468:certificate/8eba9c5e-5a11-4944-9afc-cd630c92bf55"
    instance_ids = module.instance.instance_ids
}


module "instance" {
    source = "../modules/instance"

    ami                       = var.ami
    instance_type             = var.instance_type
    #ebs_size                  = var.instance_ebs_size
    #user_data                 = var.instance_user_data
    #kms_key_id                = var.ebs_kms_key_id
    #ec2-iam-role-profile-name = module.iam-service-role.ec2-iam-role-profile.name
    ssh_allow_comm_list       = [var.subnet_app_az1, var.subnet_app_az2]
    subnet_ids = module.vpc.private_app_subnet_ids
    target_group_arns = [module.alb.target_group_arn]

    associate_public_ip_address = var.associate_public_ip_address

  subnet_id = module.vpc.public-az1.id
  vpc_id    = module.vpc.vpc_id
  user_data = <<-EOF
#!/bin/bash 
sudo yum update -y 
sudo yum install -y nginx
echo "<h1>shndahye test page</h1>" | sudo tee /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx
EOF

    isPortForwarding = false   
#   #SecurityGroup
   sg_ec2_ids = [aws_security_group.sg-ec2.id]
#   depends_on = [module.vpc.sg-ec2-comm, module.iam-service-role.ec2-iam-role-profile]
}

module "aws_route53" {
  source = "../modules/route53"

  alb_dns_name = module.alb.alb_dns_name
}

resource "aws_security_group" "sg-ec2" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# module "s3" {
#     source = "../modules/s3"
# }