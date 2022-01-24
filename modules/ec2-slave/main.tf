resource "aws_instance" "mis_vms" {
  count                       = var.cantidad_instancias
  ami                         = var.win_server_ami[var.region] #var.imagen_OS 
  instance_type               = var.tipo_instancia
  availability_zone           = var.AZs[count.index]
  subnet_id                   = var.los_IDs_subredes[count.index]
  vpc_security_group_ids      = [var.los_SG]
  user_data                   = data.template_file.userdata_linux_ubuntu_2.rendered
  key_name                    = aws_key_pair.mi_ssh_key_2.key_name
  tags = { Name = "srv-${var.tipo_subred}-${var.proyecto}-${count.index + 1}" }
}

data "template_file" "userdata_linux_ubuntu_2" {
  template = <<-EOT
              #!/bin/bash
              INICIO=$(date "+%F %H:%M:%S")
              echo "Hora de inicio del script: $INICIO" > /home/ubuntu/a_file.txt

              echo "ubuntu:123456" | chpasswd
              sudo apt update -y && sudo apt upgrade -y
              sudo apt install openjdk-11-jdk -y
              sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              sudo sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
              sudo service sshd restart

              echo "El nombre del proyecto es ${var.proyecto}" > /home/ubuntu/b_file.txt
              FINAL=$(date "+%F %H:%M:%S")
              echo "Hora de finalizacion del script: $FINAL" >> /home/ubuntu/a_file.txt
              EOT
}

resource "aws_key_pair" "mi_ssh_key_2" {
  key_name = "srv-key-pair-2"
  public_key = file(var.ubicacion_public_key)
}