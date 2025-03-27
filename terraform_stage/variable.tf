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