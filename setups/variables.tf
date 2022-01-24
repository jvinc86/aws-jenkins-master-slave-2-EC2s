variable "REGION" { default = "eu-west-3" }               #OJO si se modifica la region deben adaptarse abajo los AV_ZONES
variable "BLOQUE_CIDR_VPC" { default = "192.168.0.0/16" } #OJO si se modifica la VPC deben adaptarse abajo los CIDR_SUBRED
variable "NOMBRE_PROYECTO" { default = "mi_maravilloso_proyecto" }
variable "NOMBRE_PROYECTO_2" { default = "mi_maravilloso_proyecto2" }


variable "NRO_DE_SUBREDES" { default = 3 } #OJO si se modifica este numero, tambien debe modificarse/adaptarse las variables de abajo 
variable "AV_ZONES" { default = ["eu-west-3a", "eu-west-3b", "eu-west-3c"] }
variable "CIDR_PRIVADOS_SUBRED" { default = ["192.168.80.0/24", "192.168.81.0/24", "192.168.82.0/24"] }
variable "CIDR_PUBLICOS_SUBRED" { default = ["192.168.120.0/24", "192.168.121.0/24", "192.168.122.0/24"] }


variable "TIPO_INSTANCIA" { default = "t2.micro" }
variable "WIN_SERVER_AMI" {
  type = map(string)
  default = {
    us-east-1 = "ami-0d80714a054d3360c", # WindowsServer (Northern Virginia)
    us-west-1 = "ami-0fc6888a6bb1dfba6", # WindowsServer (California)
    eu-west-3 = "ami-05fb43e0cf8358e9a"  # WindowsServer (Paris)
  }
}
# variable "CANTIDAD_INSTANCIAS" { default = 3 }
variable "INSTANCE_USERNAME" { default = "vincent" }
variable "INSTANCE_PASSWORD" { default = "Password!1234" }

variable "RUTA_LLAVE_PUBLICA" { default = "C:/Users/jvinc/.ssh/id_rsa.pub" }
