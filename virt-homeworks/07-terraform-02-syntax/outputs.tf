output "account_id" {
  description = "Id Аккаунта"
  value = data.aws_caller_identity.current.account_id
}
output "user_id" {
  description = "Id пользователя"
  value = data.aws_caller_identity.current.user_id
}
//регион
output "region" {
  description = "Регион"
  value = data.aws_region.current.name
}

output "private_ip" {
  description = "Приватный Ip адресс"
  value = aws_instance.example.*.private_ip
}
output "subnet_id" {
  description = "Id подсети"
  value = aws_instance.example.*.subnet_id
}
