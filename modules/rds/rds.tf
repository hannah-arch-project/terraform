resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "${var.name}-subnet-group"
  }
}

resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "RDS SG"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow MySQL from EC2 SG"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [var.ec2_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

#   tags = {
#     Name = "${var.name}-rds-sg"
#   }
}

resource "aws_db_instance" "this" {
  identifier             = var.name
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false

#   tags = {
#     Name = "${var.name}-rds"
#   }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL access from EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_sg_id] # EC2의 SG에서 접근 허용
    description     = "Allow MySQL from EC2"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

