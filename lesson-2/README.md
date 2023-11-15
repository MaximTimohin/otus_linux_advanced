### OTUS_LINUX_ADVANCED
### Lesson-2
#### Первый терраформ скрипт
###  




##### Цель:

* Создать первый терраформ скрипт


### Настройка:

###### Настраиваем

<details>

###  Проверяем параметры созданного Yandex облака
###### - manual https://cloud.yandex.ru/docs/cli/operations/
<summary>Yandex cloud config list</summary>

```
yc config list
service-account-key:
  id: ajek8kjp5iohf.......
  service_account_id: aje0f3iob5ar9.......
  created_at: "2023-10-31T08:18:10.587620380Z"
  key_algorithm: RSA_2048
  public_key: |
    -----BEGIN PUBLIC KEY-----
    -----END PUBLIC KEY-----
    -----BEGIN PRIVATE KEY-----
    -----END PRIVATE KEY-----
cloud-id: b1gsk79pkq4lk.......
folder-id: b1g6kg9grcs7t.......
```

```
yc vpc network list
+----------------------+---------+
|          ID          |  NAME   |
+----------------------+---------+
| enpf9llg24o14....... | default |
+----------------------+---------+
```
</details>
<details>
<summary>Terraform main.tf</summary>

###  Создадим основной конфигурационный файл для terraform

```
terraform {
  required_version = ">= 0.13.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.94.0"
    }
  }
}
provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}
module "nginx" {
  source          = "./modules/nginx"
}
```

</details>

<details>
<summary>Terraform apply</summary>

#### Запустим создание инфраструктуры
```
terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
 + create

Terraform will perform the following actions:

 # module.nginx.yandex_compute_instance.nginx will be created
 + resource "yandex_compute_instance" "nginx" {
     + created_at                = (known after apply)
     + folder_id                 = (known after apply)
     + fqdn                      = (known after apply)
     + gpu_cluster_id            = (known after apply)
     + hostname                  = (known after apply)
     + id                        = (known after apply)
     + labels                    = {
         + "tags" = "nginx"
       }
     + metadata                  = {
         + "user-data" = <<-EOT
               #cloud-config
               users:
                 - name: yc-user
                   groups: sudo
                   shell: /bin/bash
                   sudo: ['ALL=(ALL) NOPASSWD:ALL']
                   ssh-authorized-keys:
                     - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNJstucDhCgnroFYV4q9KiUYaYolr3kZVDsy+s0sBbkZ1sbw3jd4/TiS9+qTceCBtd90A8FyVy0VlxUsxqKrLD4vLBdOdenIgWazYn5UNPlprgDUIfpxggLkI/UtAL0s3oY0iKMPsafJH3jHnkSycY+i/nPZ20+S3UMuVv/TKGU0Vsga0lNUkHKTVHfvMwlQ9IidA5lH7RklOeMpsWRuQ7WzAlT+Vxylbl8m1GKKLussoVNO/ZiMBkZDEZE/vQTJJZLskOkAdr9DeRjxipi/cxgbknoIBG5lM8mtAgOGs5jdD8SMu1NmbW61MieOzOgFeuqUr0a9WVUlSgYBuOtKd4Q8OQrDTQs0qXUht0Si7JargX9NA7dZ5BZwA5aUq6I4H40gnVKlfj0nveVIOQRUzCS1lTgLQoCzkgV8qOap3EVWiLXMbgCfXB/1Vg1ivbfeawc7c6fFZwmfUVfll2s2lwCefAxcsthrjzSR8JJ1ImzCCnXsIDU+zSA9lm+Yzu42M= root@tmv-lab
                 - name: maxim
                   groups: sudo
                   shell: /bin/bash
                   sudo: ['ALL=(ALL) NOPASSWD:ALL']
                   ssh-authorized-keys:
                     - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNJstucDhCgnroFYV4q9KiUYaYolr3kZVDsy+s0sBbkZ1sbw3jd4/TiS9+qTceCBtd90A8FyVy0VlxUsxqKrLD4vLBdOdenIgWazYn5UNPlprgDUIfpxggLkI/UtAL0s3oY0iKMPsafJH3jHnkSycY+i/nPZ20+S3UMuVv/TKGU0Vsga0lNUkHKTVHfvMwlQ9IidA5lH7RklOeMpsWRuQ7WzAlT+Vxylbl8m1GKKLussoVNO/ZiMBkZDEZE/vQTJJZLskOkAdr9DeRjxipi/cxgbknoIBG5lM8mtAgOGs5jdD8SMu1NmbW61MieOzOgFeuqUr0a9WVUlSgYBuOtKd4Q8OQrDTQs0qXUht0Si7JargX9NA7dZ5BZwA5aUq6I4H40gnVKlfj0nveVIOQRUzCS1lTgLQoCzkgV8qOap3EVWiLXMbgCfXB/1Vg1ivbfeawc7c6fFZwmfUVfll2s2lwCefAxcsthrjzSR8JJ1ImzCCnXsIDU+zSA9lm+Yzu42M= root@tmv-lab
               apt:
               package_update: true
               package_upgrade: true
               packages:
                 - nano
                 - nginx
               runcmd:
                 - sudo systemctl start nginx
                 - sudo systemctl enable nginx
           EOT
       }
     + name                      = "nginx"
     + network_acceleration_type = "standard"
     + platform_id               = "standard-v1"
     + service_account_id        = (known after apply)
     + status                    = (known after apply)
     + zone                      = (known after apply)

     + boot_disk {
         + auto_delete = true
         + device_name = (known after apply)
         + disk_id     = (known after apply)
         + mode        = (known after apply)

         + initialize_params {
             + block_size  = (known after apply)
             + description = (known after apply)
             + image_id    = "fd8m3j9ott9u69hks0gg"
             + name        = (known after apply)
             + size        = (known after apply)
             + snapshot_id = (known after apply)
             + type        = "network-hdd"
           }
       }

     + network_interface {
         + index              = (known after apply)
         + ip_address         = (known after apply)
         + ipv4               = true
         + ipv6               = (known after apply)
         + ipv6_address       = (known after apply)
         + mac_address        = (known after apply)
         + nat                = true
         + nat_ip_address     = (known after apply)
         + nat_ip_version     = (known after apply)
         + security_group_ids = (known after apply)
         + subnet_id          = (known after apply)
       }

     + resources {
         + core_fraction = 5
         + cores         = 2
         + memory        = 2
       }

     + scheduling_policy {
         + preemptible = true
       }
   }

 # module.nginx.yandex_vpc_network.nginx_vpc will be created
 + resource "yandex_vpc_network" "nginx_vpc" {
     + created_at                = (known after apply)
     + default_security_group_id = (known after apply)
     + folder_id                 = (known after apply)
     + id                        = (known after apply)
     + labels                    = (known after apply)
     + name                      = "nginx_vpc"
     + subnet_ids                = (known after apply)
   }

 # module.nginx.yandex_vpc_security_group.nginx_security will be created
 + resource "yandex_vpc_security_group" "nginx_security" {
     + created_at  = (known after apply)
     + description = "Nginx Security group"
     + folder_id   = (known after apply)
     + id          = (known after apply)
     + labels      = (known after apply)
     + name        = "Nginx security group"
     + network_id  = (known after apply)
     + status      = (known after apply)

     + egress {
         + description    = "Outcoming traf"
         + from_port      = -1
         + id             = (known after apply)
         + labels         = (known after apply)
         + port           = -1
         + protocol       = "ANY"
         + to_port        = -1
         + v4_cidr_blocks = [
             + "0.0.0.0/0",
           ]
         + v6_cidr_blocks = []
       }

     + ingress {
         + from_port      = -1
         + id             = (known after apply)
         + labels         = (known after apply)
         + port           = 22
         + protocol       = "TCP"
         + to_port        = -1
         + v4_cidr_blocks = [
             + "0.0.0.0/0",
           ]
         + v6_cidr_blocks = []
       }
     + ingress {
         + from_port      = -1
         + id             = (known after apply)
         + labels         = (known after apply)
         + port           = 443
         + protocol       = "TCP"
         + to_port        = -1
         + v4_cidr_blocks = [
             + "0.0.0.0/0",
           ]
         + v6_cidr_blocks = []
       }
     + ingress {
         + from_port      = -1
         + id             = (known after apply)
         + labels         = (known after apply)
         + port           = 80
         + protocol       = "TCP"
         + to_port        = -1
         + v4_cidr_blocks = [
             + "0.0.0.0/0",
           ]
         + v6_cidr_blocks = []
       }
   }

 # module.nginx.yandex_vpc_subnet.otus_network will be created
 + resource "yandex_vpc_subnet" "otus_network" {
     + created_at     = (known after apply)
     + folder_id      = (known after apply)
     + id             = (known after apply)
     + labels         = (known after apply)
     + name           = (known after apply)
     + network_id     = (known after apply)
     + v4_cidr_blocks = [
         + "10.10.10.0/24",
       ]
     + v6_cidr_blocks = (known after apply)
     + zone           = "ru-central1-a"
   }

Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
 Terraform will perform the actions described above.
 Only 'yes' will be accepted to approve.
```


#### Инфраструктура собралась

```
module.nginx.yandex_compute_instance.nginx: Creation complete after 44s [id=fhmbnpekbqt0p.......]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```
</details>

<details>
<summary>CURL</summary>


#### Проверим доступен ли Nginx

```
/otus/terraform# curl -s http://158.160.52.78
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
```

</details>

##### Выводы:
Инфраструктура собралась и запустилась. Nginx Доступен.
