resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = element(data.terraform_remote_state.vpc.outputs.public_subnet_id[*], 0)
  associate_public_ip_address = var.public_ip
  vpc_security_group_ids = [aws_security_group.port22and80.id]
  key_name = var.key_name

  tags = {
    Name = var.instance_name
  }
}
# Null resource to handle the conditional provisioner
resource "null_resource" "provision" {
  count = var.provisioner == true ? 1 : 0  # Only runs if provisioner is true

  # Connection block for the remote-exec provisioner
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.path_pem_file)
      host        = aws_instance.ubuntu.public_ip
    }

    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y",
      "echo '<h1>hi this is Web Server $(hostname)</h1>' | sudo tee /var/www/html/index.html",
      "sudo systemctl restart apache2",
      "sudo systemctl enable apache2"
    ]
  }
}

resource "aws_security_group" "port22and80" {
  name = var.sg_name
  description = "Allow only port 22 and 80"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc-id
  tags = {
    Name = var.sg_name
  }

dynamic "ingress" {
  for_each = var.sg_ing_ports
  content {
    from_port        = ingress.value
    to_port          = ingress.value
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

dynamic "egress" {
  for_each = var.sg_egress_ports
  content {
    from_port        = egress.value
    to_port          = egress.value
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
}