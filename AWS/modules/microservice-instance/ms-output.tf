resource "random_id" "app_name_suffix" {
  byte_length = 4
}

resource "aws_instance" "apps" {

  for_each = toset(var.zones )  #Permite crear una instancia de EC2 para cada zona de disponibilidad definida
  availability_zone = each.key
  ami = var.image
  instance_type = var.instance_type
  tags = {  
    Name = "apps-${random_id.app_name_suffix.hex}"
  }
}