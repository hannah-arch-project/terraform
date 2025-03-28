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
    certificate_arn = var.acm_certificate_arn_ap
    instance_ids = module.instance.instance_ids
}


module "instance" {
    source = "../modules/instance"

    ami                       = var.ami
    instance_type             = var.instance_type
    #ebs_size                  = var.instance_ebs_size
    #kms_key_id                = var.ebs_kms_key_id
    #ec2-iam-role-profile-name = module.iam-service-role.ec2-iam-role-profile.name
    ssh_allow_comm_list       = [var.subnet_app_az1, var.subnet_app_az2]
    subnet_ids = module.vpc.private_app_subnet_ids
    target_group_arns = [module.alb.target_group_arn]

    associate_public_ip_address = var.associate_public_ip_address

    subnet_id = module.vpc.public-az1.id
    vpc_id    = module.vpc.vpc_id

    # user_data = data.template_file.wordpress_user_data.rendered
    user_data = data.template_file.user_data.rendered
    

    isPortForwarding = false   
#   #SecurityGroup
   sg_ec2_ids = [aws_security_group.sg-ec2.id]
#   depends_on = [module.vpc.sg-ec2-comm, module.iam-service-role.ec2-iam-role-profile]
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata.sh")
  vars = {
    db_name = module.rds.db_name
    db_user = module.rds.db_username
    db_pass = module.rds.db_password
    rds_endpoint = module.rds.rds_endpoint
  }
}

# data "template_file" "wordpress_user_data" {
#   template = file("${path.module}/wordpress_userdata.sh")
#   vars = {
#     db_name = module.rds.db_name
#     db_user = module.rds.db_username
#     db_pass = module.rds.db_password
#     rds_endpoint = module.rds.rds_endpoint
#   }
# }

module "aws_route53" {
  source = "../modules/route53"

  alb_dns_name = module.alb.alb_dns_name
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  cloudfront_zone_id     = module.cloudfront.cloudfront_zone_id
}

module "rds" {
  source = "../modules/rds"

  name              = "wordpress"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_db_subnet_ids
  ec2_sg_id         = module.instance.ec2_sg_id

  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  db_name            = var.db_name
  db_username        = var.db_user
  db_password        = var.db_pass
}

module "frontend_bucket" {
  source = "../modules/s3/frontend"

  frontend_bucket_name = "www.shndh.kro.kr"
  oai_iam_arn = module.cloudfront.oai_iam_arn
}

module "backend_bucket" {
  source = "../modules/s3/backend"

  backend_bucket_name = "hannah-backend-bucket"
}

module "cloudfront" {
  source = "../modules/cloudfront"

  domain_name = module.frontend_bucket.domain_name
  acm_certificate_arn = var.acm_certificate_arn_us  
}

module "iam-service-role" {
  source = "../modules/iam/iam-service-role"

}

module "codedeploy" {
  source = "../modules/codedeploy"

  codedeploy_app_name            = var.codedeploy_app_name
  codedeploy_deployment_group_name = var.codedeploy_deployment_group_name
  codedeploy_service_role_arn    = module.iam-service-role.codedeploy_iam_role_arn

  ec2_tag_key   = var.ec2_tag_key
  ec2_tag_value = var.ec2_tag_value
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