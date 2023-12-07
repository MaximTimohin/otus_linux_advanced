locals {
  vm_user         = "debian"
  vpc_name = "my_vpc_network"
  subnet_cidrs = ["10.10.11.0/24"]
  subnet_name = "my_vpc_subnet"
}

resource "yandex_vpc_network" "vpc" {
  name = local.vpc_name
}

resource "yandex_vpc_subnet" "subnet" {
  v4_cidr_blocks = local.subnet_cidrs
  zone           = var.zone
  name           = local.subnet_name
  network_id     = yandex_vpc_network.vpc.id
}

module "loadbalancers" {
  source = "./modules/instances"

  count = 1

  vm_name = "loadbalancer-${count.index + 1}"
  vpc_name = local.vpc_name
  subnet_cidrs = yandex_vpc_subnet.subnet.v4_cidr_blocks
  subnet_name = yandex_vpc_subnet.subnet.name
  subnet_id = yandex_vpc_subnet.subnet.id
  vm_user = local.vm_user
}

module "backends" {
  source = "./modules/instances"

  count = 2

  vm_name = "backend-${count.index + 1}"
  vpc_name = local.vpc_name
  subnet_cidrs = yandex_vpc_subnet.subnet.v4_cidr_blocks
  subnet_name = yandex_vpc_subnet.subnet.name
  subnet_id = yandex_vpc_subnet.subnet.id
  vm_user = local.vm_user
}

module "databases" {
  source = "./modules/instances"

  count = 1

  vm_name = "database-${count.index + 1}"
  vpc_name = local.vpc_name
  subnet_cidrs = yandex_vpc_subnet.subnet.v4_cidr_blocks
  subnet_name = yandex_vpc_subnet.subnet.name
  subnet_id = yandex_vpc_subnet.subnet.id
  vm_user = local.vm_user
}

resource "local_file" "inventory_file" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      loadbalancers = module.loadbalancers
      backends      = module.backends
      databases     = module.databases
    }
  )
  filename = "${path.module}/inventory.ini"
}

resource "local_file" "group_vars_all_file" {
  content = templatefile("${path.module}/templates/group_vars_all.tpl",
    {
      loadbalancers = module.loadbalancers
      backends      = module.backends
      databases     = module.databases
    }
  )
  filename = "${path.module}/group_vars/all/main.yml"
}
