output "rds_endpoints" {
  value = {
    for key, instance in aws_db_instance.db_instances :
    key => instance.endpoint
  }
<<<<<<< HEAD
}

output "secrets_manager_secret_arn" {
  value     = aws_secretsmanager_secret.secretdb.arn
  sensitive = true
}



=======
}

output "secrets_manager_secret_arn" {
  value     = aws_secretsmanager_secret.secretdb.arn
  sensitive = true
}
>>>>>>> 5a414d40ba8b957aa6985f554151a403a9647e3f
