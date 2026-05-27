resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-rds-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier                   = "${var.project_name}-postgres"
  engine                       = "postgres"
  engine_version               = "15.18"
  instance_class               = "db.t3.micro"
  allocated_storage            = 20
  storage_type                 = "gp2"
  db_name                      = "postgres"
  username                     = var.db_username
  password                     = var.db_password
  db_subnet_group_name         = aws_db_subnet_group.default.name
  vpc_security_group_ids       = [var.rds_sg_id]
  publicly_accessible          = true
  multi_az                     = false
  backup_retention_period      = 0
  auto_minor_version_upgrade   = true
  deletion_protection          = false
  skip_final_snapshot          = true
  apply_immediately            = true
  performance_insights_enabled = false

  tags = {
    Name = "${var.project_name}-postgres"
  }
}
