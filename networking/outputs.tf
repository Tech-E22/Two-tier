# networking/outputs.tf 

output "vpc_id" {
  value = aws_vpc.wk21_vpc.id
}

output "public_sg" {
  value = aws_security_group.wk21_public_sg.id
}

output "private_sg" {
  value = aws_security_group.wk21_private_sg.id
}

output "web_sg" {
  value = aws_security_group.wk21_web_sg.id
}

output "private_subnet" {
  value = aws_subnet.wk21_private_subnet[*].id
}

output "public_subnet" {
  value = aws_subnet.wk21_public_subnet[*].id
}