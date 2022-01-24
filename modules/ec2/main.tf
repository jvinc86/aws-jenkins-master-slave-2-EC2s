resource "aws_instance" "mis_vms" {
  count                       = var.cantidad_instancias
  ami                         = var.win_server_ami[var.region] #var.imagen_OS 
  instance_type               = var.tipo_instancia
  availability_zone           = var.AZs[count.index]
  subnet_id                   = var.los_IDs_subredes[count.index]
  vpc_security_group_ids      = [aws_security_group.mi_sec_group.id]
  user_data                   = data.template_file.userdata_linux_ubuntu.rendered
  key_name                    = aws_key_pair.mi_ssh_key.key_name

  tags = { Name = "srv-${var.tipo_subred}-${var.proyecto}-${count.index + 1}" }
}

resource "aws_key_pair" "mi_ssh_key" {
  key_name = "srv-key-pair"
  public_key = file(var.ubicacion_public_key)
}

data "template_file" "userdata_linux_ubuntu" {
  template = <<-EOT
              #!/bin/bash
              INICIO=$(date "+%F %H:%M:%S")
              echo "Hora de inicio del script: $INICIO" > /home/ubuntu/a_file.txt

              echo "ubuntu:123456" | chpasswd
              sudo apt update -y && sudo apt upgrade -y
              sudo apt install xrdp -y
              sudo systemctl enable xrdp
              sudo apt install tightvncserver -y
              sudo apt install ubuntu-gnome-desktop gnome-shell gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal -y
              sudo apt install openjdk-11-jdk -y
              sudo apt install git -y
              sudo apt install maven -y
              wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
              sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
              sudo apt update -y
              sudo apt install jenkins -y
              sudo systemctl start jenkins
              sudo cat /var/lib/jenkins/secrets/initialAdminPassword | sudo tee -a  /home/ubuntu/contrasena_de_Jenkins.txt
              sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              sudo sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
              sudo service sshd restart

              echo "El nombre del proyecto es ${var.proyecto}" > /home/ubuntu/b_file.txt
              FINAL=$(date "+%F %H:%M:%S")
              echo "Hora de finalizacion del script: $FINAL" >> /home/ubuntu/a_file.txt
              EOT
}

locals {
  reglas_ingress = [
    { puerto = 3389
      resumen = "Puerto RDP" },
    { puerto = 22
      resumen = "Puerto SSH" },
    { puerto = 80
      resumen = "Puerto HTTP" },
    { puerto = 8080
      resumen = "Puerto HTTP_2" },
    { puerto = 443
      resumen = "Puerto HTTPS" }
  ]
}
resource "aws_security_group" "mi_sec_group" {
  name   = "${var.proyecto}-sg-${var.tipo_subred}"
  vpc_id = var.el_id_de_la_VPC

  dynamic "ingress" {
    for_each = local.reglas_ingress

    content {
      description = ingress.value.resumen
      from_port   = ingress.value.puerto
      to_port     = ingress.value.puerto
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description      = "Permitir PING"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-${var.tipo_subred}-${var.proyecto}" }

}

resource "aws_network_acl" "mi_network_acl" {
  vpc_id     = var.el_id_de_la_VPC
  subnet_ids = var.los_IDs_subredes

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = { Name = "acl-${var.tipo_subred}-${var.proyecto}" }
}