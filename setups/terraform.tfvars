REGION            = "eu-west-3"
BLOQUE_CIDR_VPC   = "10.0.0.0/16"
NOMBRE_PROYECTO   = "jenkins"
NOMBRE_PROYECTO_2 = "jenkins-slave"

NRO_DE_SUBREDES      = 1               # 3
AV_ZONES             = ["eu-west-3a"]  # ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
CIDR_PRIVADOS_SUBRED = ["10.0.0.0/24"] # ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
CIDR_PUBLICOS_SUBRED = ["10.0.3.0/24"] # ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]

# CANTIDAD_INSTANCIAS = 3
TIPO_INSTANCIA      = "t2.large"
INSTANCE_USERNAME   = "vincent"
INSTANCE_PASSWORD   = "Password!1234"
WIN_SERVER_AMI = {
  us-east-1 = "ami-04505e74c0741db8d", # Ubuntu 20.04 (Virginia)
  us-west-1 = "ami-01f87c43e618bf8f0", # Ubuntu 20.04 (California)
  eu-west-3 = "ami-0c6ebbd55ab05f070"  # Ubuntu 20.04 (Paris)
}

RUTA_LLAVE_PUBLICA = "C:/Users/jvinc/.ssh/id_rsa.pub"