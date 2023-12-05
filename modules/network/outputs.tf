<<<<<<< HEAD
output "vpc_id" {
  value = aws_vpc.demovpc.id
}
output "public_subnets" {
  value = { for k, v in aws_subnet.public_subnets : k => v.id }
}

output "private_subnets" {
  value = { for k, v in aws_subnet.private_subnets : k => v.id }
}
=======
output "public_subnet2_id" {
  value = aws_subnet.public_subnet2.id
}
output "public_subnet1_id" {
  value = aws_subnet.public_subnet1.id
}
output "vpc_id" {
  value = aws_vpc.demovpc.id
}
output "private_subnet1_id" {
  value = aws_subnet.private_subnet1.id
}
output "private_subnet2_id" {
  value = aws_subnet.private_subnet2.id
}
>>>>>>> 5a414d40ba8b957aa6985f554151a403a9647e3f
