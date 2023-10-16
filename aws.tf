#Desarrollar las configuraciones
#Proveedor
provider "aws" {
  region = "us-west-2" # Especificar región
}

#Creación de VM
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # AMI de la máquina virtual
  instance_type = "t2.micro" # Tipo de instancia
}

# Grupo de Seguridad
resource "aws_security_group" "instance" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Volumen de almacenamiento
resource "aws_ebs_volume" "example" {
  availability_zone = "us-west-2a" # Zona de disponibilidad de la región especificada
  size              = 1 # Tamaño del almacenamiento en GB
  tags = {
    Name = "example_volume"
  }
}
