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
  instance_class               = "db.t3.small"
  allocated_storage            = 20
  max_allocated_storage        = 100
  storage_type                 = "gp3"
  iops                         = 3000
  storage_throughput           = 125
  db_name                      = "postgres"
  username                     = var.db_username
  password                     = var.db_password
  db_subnet_group_name         = aws_db_subnet_group.default.name
  vpc_security_group_ids       = [var.rds_sg_id]
  publicly_accessible          = true
  multi_az                     = false
  backup_retention_period      = 7
  backup_window                = "03:00-04:00"
  maintenance_window           = "sun:04:00-sun:05:00"
  auto_minor_version_upgrade   = true
  copy_tags_to_snapshot        = true
  deletion_protection          = true
  final_snapshot_identifier    = "${var.project_name}-postgres-final-snapshot"
  skip_final_snapshot          = false
  apply_immediately            = false
  performance_insights_enabled = true
  storage_encrypted            = true

  tags = {
    Name = "${var.project_name}-postgres"
  }
}
