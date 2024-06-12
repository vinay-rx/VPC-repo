resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "iam_profile"
  role = aws_iam_role.Instance_role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
   
  }
  
}


resource "aws_iam_role" "Instance_role" {
  name               = "iam_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

}
resource "aws_iam_policy_attachment" "ssm_manager_attachment" {
  name       = "ssm-manager-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  roles      = [aws_iam_role.Instance_role.name]
}

# data "aws_subnet_ids" "test_subnet_ids" {
#   vpc_id = var.vpc_id
#   tags = {
#     Tier = "Public"
#   }
# }

# data "aws_subnet" "test_subnet" {
#   count = "${length(data.aws_subnet_ids.test_subnet_ids.ids)}"
#   id    = "${tolist(data.aws_subnet_ids.test_subnet_ids.ids)[count.index]}"
# }


resource "aws_instance" "Test-ec2" {
  ami              = var.ec2_ami
  instance_type    = var.instance_type
  key_name   = var.key_name
  vpc_security_group_ids = var.security_groups
  subnet_id = var.subnet_id
  monitoring = true
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp2"
    delete_on_termination = true
  }
  #user_data = var.user_data
  tags = merge(
     var.common_tags
   )

  # provisioner "local-exec" {
  #   command = "echo ${self.public_ip} > ip_address.txt"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt-get update -y",
  #     "sudo apt-get install -y ansible",
  #     "ansible-playbook -i ${self.public_ip}, -u ubuntu --private-key ${var.private_key_path} /path/to/install_docker_and_php.yml"
  #   ]
  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     private_key = file(var.private_key_path)
  #     host        = self.public_ip
  #   }
  # }
}
 // Add key

