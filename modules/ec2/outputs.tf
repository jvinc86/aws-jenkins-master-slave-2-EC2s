output "mis_ip_privadas" { value = aws_instance.mis_vms.*.private_ip }
output "mis_ip_publicas" { value = aws_instance.mis_vms.*.public_ip }
output "ID_sec_group" { value = aws_security_group.mi_sec_group.id }

