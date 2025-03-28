variable "region" {
  type = string
  default = "ap-northeast-2"
}
variable "stage" {
  type = string
  default = "stage"
}
# 각 값 수정 필요
# variable "servicename" {
#   type = string
#   default = "terraform_sdahye"
# }
# variable "tags" {
#   type = map(string)
#   default = {
#     "name" = "sdahye_VPC"
#   }
# }

#VPC
variable "az" {
  type = list(any)
  default = [ "ap-northeast-2a", "ap-northeast-2c" ]
}
variable "vpc_ip_range" {
  type = string
  default = "10.1.0.0/16"
}

variable "subnet_public_az1" {
  type = string
  default = "10.1.0.0/24"
}
variable "subnet_public_az2" {
  type = string
  default = "10.1.3.0/24"
}

variable "subnet_app_az1" {
  type = string
  default = "10.1.1.0/24"
}
variable "subnet_app_az2" {
  type = string
  default = "10.1.4.0/24"
}

variable "subnet_db_az1" {
  type = string
  default = "10.1.2.0/24"
}

variable "subnet_db_az2" {
  type = string
  default = "10.1.5.0/24"
}

#Instance
variable "ami"{
  type = string
  default = "ami-062cddb9d94dcf95d"
}
variable "instance_type" {
  type = string
  default = "t3.micro"
}
# variable "instance_ebs_size" {
#   type = number
#   default = 20
# }
# variable "instance_ebs_volume" {
#   type = string
#   default = "gp3"
# }

variable "associate_public_ip_address" {
  type = bool
  default = true
}

# acm
variable "acm_certificate_arn_us" {
    type = string
    default = "arn:aws:acm:us-east-1:405894838468:certificate/66ca7e38-b04f-4307-9ec6-78856b9f9912"
}

variable "acm_certificate_arn_ap" {
    type = string
    default = "arn:aws:acm:ap-northeast-2:405894838468:certificate/8eba9c5e-5a11-4944-9afc-cd630c92bf55"
}

#rds
variable "db_name" {
  description = "RDS DB name"
  default = "wordpress"
  type = string
}
variable "db_user" {
  description = "RDS user"
  default = "admin"
  type = string
}
variable "db_pass" {
  description = "RDS DB password"
  default = "shndahye908"
  type        = string
  #sensitive   = true
}
