output "vpc-id" {
  # value = var.enable_autoscaling ? "${google_compute_instance_template.webserver[0].self_link}" : ""
  value = aws_vpc.aws-vpc.id
}
