# -- network/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.maniak_vpc.id
}
output "public_sg" {
  value = aws_security_group.maniak_sg["public"].id
}
output "bastion_sg" {
  value = aws_security_group.maniak_sg["bastion"].id
}
output "public_subnets" {
  value = aws_subnet.maniak_public_subnet.*.id
}
output "consul_sg" {
  value = aws_security_group.maniak_sg["consul"].id
}
output "vault_sg" {
  value = aws_security_group.maniak_sg["vault"].id
}