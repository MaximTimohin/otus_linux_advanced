resource "yandex_compute_instance" "default" {
  platform_id = "standard-v1"
  hostname    = "node-${count.index}"
  count       = 3

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
      image_id = "fd8vm24pae6k98274k7o" #(CentOS-7)
    }

  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.custom_subnet.id
    security_group_ids = [yandex_vpc_security_group.custom_group.id]
    nat                = true
  }

  metadata = {
    user-data = "${file("./cloud-config/base.yaml")}"
  }
  provisioner "local-exec" {
    when    = create
    command = <<EOF
    echo "[node${count.index}]" >> hosts.ini
    echo "${self.network_interface.0.nat_ip_address}" >> hosts.ini
    EOF
  }
}

resource "yandex_compute_instance" "storage" {
  platform_id = "standard-v1"
  hostname    = "storage"
  depends_on  = [yandex_compute_instance.default]

  resources {
    cores  = 2
    memory = 2
    core_fraction = 5
  }
  scheduling_policy {
    preemptible = true
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.empty-disk.id
    auto_delete = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vm24pae6k98274k7o" #(CentOS-7)
    }

  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.custom_subnet.id
    security_group_ids = [yandex_vpc_security_group.custom_group.id]
    nat                = true
    ip_address         = "10.10.11.254"
  }

  metadata = {
    user-data = "${file("./cloud-config/base.yaml")}"
  }
  provisioner "local-exec" {
    when    = create
    command = <<EOF
    echo "[cluster:children]" >> hosts.ini
    echo "node0\nnode1\nnode2" >> hosts.ini
    echo "[storage]" >> hosts.ini
    echo "${self.network_interface.0.nat_ip_address}" >> hosts.ini
    ansible-playbook -u maxim -i hosts.ini --private-key ${var.private_key_path} pacemaker-playbook.yml --extra-var "storage_ip=${self.network_interface.0.nat_ip_address}"
    rm -rf hosts.ini
    EOF
  }
}

resource "yandex_compute_disk" "empty-disk" {
  name = "empty-disk"
  type = "network-hdd"
  size = 5
}


resource "yandex_vpc_network" "custom_vpc" {
  name = "custom_vpc"

}
resource "yandex_vpc_subnet" "custom_subnet" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.custom_vpc.id
  v4_cidr_blocks = ["10.10.11.0/24"]
}



resource "yandex_vpc_security_group" "custom_group" {
  name        = "HTTP-Server  group"
  description = "My Security group"
  network_id  = yandex_vpc_network.custom_vpc.id

  dynamic "ingress" {
    for_each = ["80", "443", "22", "2224", "3121", "3260", "5403", "21064", "9929"]
    content {
      protocol       = "TCP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = ingress.value
    }
  }

  dynamic "ingress" {
    for_each = ["5404", "5405", "9929"]
    content {
      protocol       = "UDP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = ingress.value
    }
  }

  egress {
    protocol       = "ANY"
    description    = "Out"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = -1
  }
}
#}
