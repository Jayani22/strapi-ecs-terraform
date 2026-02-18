module "ecr" {
    source = "./modules/ecr"
    name   = "strapi-repo"
}

module "ecs" {
    source    = "./modules/ecs"
    image_uri = var.image_uri
}