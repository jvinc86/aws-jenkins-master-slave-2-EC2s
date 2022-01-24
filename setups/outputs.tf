output "El_ID_VPC" { value = aws_vpc.mi_red.id }
output "Router_Nuevo_ID_VPC" { value = aws_vpc.mi_red.main_route_table_id }
output "Los_IDs_subredes" { value = module.subredes_publicas.IDs_subredes }

output "IP_privada_de_EC2_en_subred_publica" { value = module.vms_publicas.mis_ip_privadas }
output "IP_publica_de_EC2_en_subred_publica" { value = module.vms_publicas.mis_ip_publicas }