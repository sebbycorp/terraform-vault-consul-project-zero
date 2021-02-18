# -- root/main.tf --


module "network" {
  source           = "./network"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  private_sn_count = 3
  public_sn_count  = 3
  max_subnets      = 20
  security_groups  = local.security_groups
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  db_subnet_group  = true
}


module "bastion" {
  source          = "./bastion"
  instance_count  = "1"
  bastion_sg       = module.network.bastion_sg
  public_subnets  = module.network.public_subnets
  instance_type   = "t2.micro"
  vol_size        = "10"
  key_name        = "awskeydemo"
  public_key_path = "c:/Users/sebbycorp/.ssh/awskeydemo.pub"
  # user_data_path  = "${path.root}/userdata.tpl"

}

module "consul" {
  source          = "./consul"
  instance_count  = "1"
  consul_sg       = module.network.consul_sg
  public_subnets  = module.network.public_subnets
  instance_type   = "t2.micro"
  vol_size        = "10"
  key_name        = "awskeydemo"
  public_key_path = "c:/Users/sebbycorp/.ssh/awskeydemo.pub"

}

module "vault" {
  source          = "./vault"
  instance_count  = "1"
  vault_sg       = module.network.vault_sg
  public_subnets  = module.network.public_subnets
  instance_type   = "t2.micro"
  vol_size        = "10"
  key_name        = "awskeydemo"
  public_key_path = "c:/Users/sebbycorp/.ssh/awskeydemo.pub"

}
