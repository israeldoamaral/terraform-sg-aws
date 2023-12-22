resource "aws_security_group" "sg" {
  name = format("%s-sg", var.tag-sg)
  description = "Allow TLS inbount trafic"
  vpc_id = var.vpc

  dynamic "ingress" {
      for_each = var.sg-cidr
      content {
          description = ingress.value["description"]
          from_port   = ingress.key
          to_port     = ingress.value["to_port"]
          protocol    = ingress.value["protocol"]
          cidr_blocks = ingress.value["cidr_blocks"]
      }
  }


  egress  {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Outbound all "
  }

  tags = {
      Name = format("SG-%s", var.tag-sg)
  }
}
