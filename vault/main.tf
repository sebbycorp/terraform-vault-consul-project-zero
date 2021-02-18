# --- Vault/main.tf ---


data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "random_id" "maniak_vault_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "maniak_vault_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "maniak_vault" {
  count                  = var.instance_count
  instance_type          = var.instance_type
  ami                    = data.aws_ami.server_ami.id
  vpc_security_group_ids = [var.vault_sg]
  subnet_id              = var.public_subnets[count.index]
  key_name               = aws_key_pair.maniak_vault_auth.id
  root_block_device {
    volume_size = var.vol_size
  }
  # user_data = templatefile(var.user_data_path,
  #   {
  #     nodename    = "maniak-${random_id.maniak_node_id[count.index].dec}"
  #   }
  # )
  tags = {
    Name = "maniak-node-${random_id.maniak_vault_id[count.index].dec}"

  }


}


