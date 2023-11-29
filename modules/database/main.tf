# RDS
resource "aws_db_instance" "RDS" {
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  identifier           = var.identifier
  parameter_group_name = var.parameter_group_name
  multi_az             = var.multi_az
  storage_type         = var.storage_type
  skip_final_snapshot  = var.skip_final_snapshot
  db_name              = var.database_dbname
  username             = var.database_username
  password             = random_password.password.result
  db_subnet_group_name = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.rds-SG.id]
}
resource "aws_db_subnet_group" "rds-subnet-group" {
    name = "rds-subnet-group"
    description = "RDS subnet group"
    subnet_ids = [var.private_subnet1_id, var.private_subnet2_id]
}

#SECRETS_MANAGER
resource "aws_secretsmanager_secret" "secretdb" {
  name = "secret5"
}
resource "aws_secretsmanager_secret_version" "secretdb" {
  secret_id     = aws_secretsmanager_secret.secretdb.id
  secret_string = jsonencode({
    username = var.database_username
    password = random_password.password.result
    host     = aws_db_instance.RDS.endpoint
    dbname   = var.database_dbname
  })
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
 
#security group for database
resource "aws_security_group" "rds-SG" {
  vpc_id = var.vpc_id
  name = "rds-SG"
  description = "Allow inbound mysql traffic"
}
resource "aws_security_group_rule" "allow-mysql" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_group_id = aws_security_group.rds-SG.id
    source_security_group_id = var.security_groups
    
}
resource "aws_security_group_rule" "allow-outgoing" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_group_id = aws_security_group.rds-SG.id
    cidr_blocks = ["0.0.0.0/0"]
}
