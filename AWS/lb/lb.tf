#Configuramos el deploy del LoadBalancer en AWS - La instancuia es un EC2
resource "aws_launch_configuration" "webserver-lc" {
  name_prefix = "webserver-"

  image_id      = var.image
  instance_type = var.instance_type

  # security_groups = [aws_security_group.allow_http.name]

  associate_public_ip_address = true

  user_data = <<USER_DATA
                    #! /bin/bash
                    apt update
                    apt -y install apache2
                    cat <<EOF > /var/www/html/index.html
                    <html><body><h1>Hello World</h1>
                    <p>Basic HTML file.</p>
                    </body></html>
                    EOF
                USER_DATA
  #Indicamos que debe crearse un nuevo lanzamiento de la config antes de destruir el anterior.
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "elb-sg" {
  name        = "elb-sg"
  description = "Allow HTTP traffic through Elastic Load Balancer"
  # vpc_id = aws_vpc.xcloud-vpc.id
  vpc_id = var.vpc-id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP through ELB Security Group"
  }
}

resource "aws_elb" "webserver_elb" {
  name = "webserver-elb"
  # count = "${length(var.zones)}"
  #toset -> Convierte la lista de zonas especificas en un conjunto
  availability_zones = toset(var.zones)

  cross_zone_load_balancing = true
  health_check {
    healthy_threshold   = 2          #Numero de comprobaciones consecutivas que se realizan para comprobar que esta sano
    unhealthy_threshold = 2          #Si falla 2 veces seguidas, significa que no esta sano
    timeout             = 3          #Tiempo de espera para considerar fallo, en segundos
    interval            = 30         #Intervalo entre estados -> segundos
    target              = "HTTP:80/" #Protocolo y puerto de comprobación de estado
  }

  listener {
    lb_port           = 80 #Definimos puerto donde escucha
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }

}


resource "aws_autoscaling_group" "webserver-asg" {
  name = "${aws_launch_configuration.webserver-lc.name}-asg"

  min_size         = 1
  desired_capacity = 2
  max_size         = 3

  health_check_type = "ELB"

  availability_zones = toset(var.zones)

  # for_each = aws_elb.webserver_elb
  load_balancers = [aws_elb.webserver_elb.id]

  launch_configuration = aws_launch_configuration.webserver-lc.name

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "webserver-asg"
    propagate_at_launch = true
  }

}
