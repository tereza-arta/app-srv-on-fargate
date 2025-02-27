module "net" {
  source = "./modules/net"
  count  = 1
}

module "rds" {
  source = "./modules/rds"
  count  = 1

  vpc = module.net[0].vpc_id
}

module "ecr" {
  source = "./modules/ecr"
  count  = 1

  df_context = "app/srv"
}

module "ecs" {
  source = "./modules/ecs"
  count  = 1

  repo_url    = module.ecr[0].repo_url
  ecs_sg_id   = module.net[0].ecs_sg_id
  priv_sub_id = module.net[0].priv_sub_id
  tg_id       = module.net[0].tg_id
  db_username = module.rds[0].username
  db_password = module.rds[0].password
  db_name     = module.rds[0].db_name
  db_host     = module.rds[0].rds_0_endpoint
}
