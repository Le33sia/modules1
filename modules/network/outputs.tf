output "public_subnet2_id" {
  value = aws_subnet.Public_subnet2.id
}
output "public_subnet1_id" {
  value = aws_subnet.Public_subnet1.id
}
output "vpc_id" {
  value = aws_vpc.demovpc.id
}
output "private_subnet1_id" {
  value = aws_subnet.Private_subnet1.id
}
output "private_subnet2_id" {
  value = aws_subnet.Private_subnet2.id
}