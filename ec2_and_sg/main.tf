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

resource "null_resource" "copy_script" {
  count = var.copy_script == true ? 1 : 0  
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.path_pem_file)
      host        = aws_instance.ubuntu.public_ip
    }
    provisioner "file" {
      source = "setup.sh"
      destination = "/home/ubuntu/setup.sh"
    }
  }

resource "null_resource" "execute_script" {
  depends_on = [ null_resource.copy_script ]
  count = var.copy_script == true ? 1 : 0
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.path_pem_file)
      host = aws_instance.ubuntu.public_ip
    }

    provisioner "remote-exec" {
      inline = [ 
        "chmod +x /home/ubuntu/setup.sh",
        "/home/ubuntu/setup.sh"
       ]
    }
  }

resource "aws_security_group" "port22and80" {
  name = var.sg_name
  description = "Allow only port 22 and 80"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
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

resource "null_resource" "download_pub_ip" {
  count = var.download_pub_ip_file == true ? 1 : 0
  provisioner "local-exec" {
    command = "echo '${aws_instance.ubuntu.public_ip}' >> public_ip_ec2"
  }
}