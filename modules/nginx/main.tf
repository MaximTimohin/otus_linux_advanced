terraform {
  required_version = ">= 0.13.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.94.0"
    }
  }
}

resource "yandex_vpc_network" "nginx_vpc" {
  name = "nginx_vpc"
}

resource "yandex_vpc_subnet" "otus_network" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.nginx_vpc.id
  v4_cidr_blocks = ["10.10.10.0/24"]
}

resource "yandex_compute_instance" "nginx" {
  name = "nginx"

  labels = {
    tags = "nginx"
  }
  resources {
    cores  = 2
    memory = 2
    core_fraction = 5
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = "fd8m3j9ott9u69hks0gg"
    }
  }
  network_interface {
    subnet_id =  yandex_vpc_subnet.otus_network.id
    security_group_ids = [yandex_vpc_security_group.nginx_security.id]
    nat = true
  }

  metadata = {
    user-data = "${file("./cloud-config/nginx.yaml")}"
  }

}

resource "yandex_vpc_security_group" "nginx_security" {
  name        = "Nginx security group"
  description = "Nginx Security group"
  network_id  = yandex_vpc_network.nginx_vpc.id

 ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Outcoming traf"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = -1
  }
}
