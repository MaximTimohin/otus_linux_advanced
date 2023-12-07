#### Nginx балансировка веб-приложения.
###  




##### Цель:

* Использовать Nginx в качестве балансировщика
-- 1 виртуалка - Nginx - баансировщик.
-- 2 виртуалки - бэкенд.
-- 1 виртуалка с БД.

### Настройка:

###### Настраиваем

<details>
<summary>Terraform apply</summary>

```
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_vpc_network.vpc: Creating...
yandex_vpc_network.vpc: Creation complete after 2s [id=enp7opioqjqmp9ilkuhv]
yandex_vpc_subnet.subnet: Creating...
yandex_vpc_subnet.subnet: Creation complete after 1s [id=e9brll09kos0kv812ovj]
module.loadbalancers[0].yandex_compute_instance.instances: Creating...
module.databases[0].yandex_compute_instance.instances: Creating...
module.backends[0].yandex_compute_instance.instances: Creating...
module.backends[1].yandex_compute_instance.instances: Creating...
module.loadbalancers[0].yandex_compute_instance.instances: Still creating... [10s elapsed]
module.backends[0].yandex_compute_instance.instances: Still creating... [10s elapsed]
module.databases[0].yandex_compute_instance.instances: Still creating... [10s elapsed]
module.backends[1].yandex_compute_instance.instances: Still creating... [10s elapsed]
module.backends[0].yandex_compute_instance.instances: Still creating... [20s elapsed]
module.loadbalancers[0].yandex_compute_instance.instances: Still creating... [20s elapsed]
module.backends[1].yandex_compute_instance.instances: Still creating... [20s elapsed]
module.databases[0].yandex_compute_instance.instances: Still creating... [20s elapsed]
module.loadbalancers[0].yandex_compute_instance.instances: Still creating... [30s elapsed]
module.backends[0].yandex_compute_instance.instances: Still creating... [30s elapsed]
module.databases[0].yandex_compute_instance.instances: Still creating... [30s elapsed]
module.backends[1].yandex_compute_instance.instances: Still creating... [30s elapsed]
module.backends[0].yandex_compute_instance.instances: Creation complete after 33s [id=fhmclsgc68llv08i7qf1]
module.backends[1].yandex_compute_instance.instances: Creation complete after 34s [id=fhmlosufijglt4rou1cc]
module.databases[0].yandex_compute_instance.instances: Creation complete after 35s [id=fhm0433p5vufn86em4hr]
module.loadbalancers[0].yandex_compute_instance.instances: Still creating... [40s elapsed]
module.loadbalancers[0].yandex_compute_instance.instances: Creation complete after 40s [id=fhmhtiqoq0buvoiigr5g]
local_file.group_vars_all_file: Creating...
local_file.inventory_file: Creating...
local_file.group_vars_all_file: Creation complete after 0s [id=cbae6d35a7082908f2e76d149b91e9568c6267ab]
local_file.inventory_file: Creation complete after 0s [id=4e312e41a2b63bd5905f00c94d7724d74b699503]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

root@data:/otus/terraform/lesson-5# terraform output
backends_info = [
  {
    "ip_address" = "10.10.11.23"
    "name" = "backend-1"
    "nat_ip_address" = "130.193.49.247"
  },
  {
    "ip_address" = "10.10.11.16"
    "name" = "backend-2"
    "nat_ip_address" = "84.201.158.179"
  },
]
databases_info = [
  {
    "ip_address" = "10.10.11.13"
    "name" = "database-1"
    "nat_ip_address" = "84.201.131.103"
  },
]
loadbalancers_info = [
  {
    "ip_address" = "10.10.11.31"
    "name" = "loadbalancer-1"
    "nat_ip_address" = "158.160.48.245"
  },
]

```


#### Инфраструктура собралась

</details>



<details>
<summary>Ansible playbook</summary>

```
PLAY RECAP *************************************************************************************************************************************************************
backend-1                  : ok=20   changed=13   unreachable=0    failed=0    skipped=11   rescued=0    ignored=0   
backend-2                  : ok=20   changed=13   unreachable=0    failed=0    skipped=11   rescued=0    ignored=0   
database-1                 : ok=28   changed=21   unreachable=0    failed=0    skipped=12   rescued=0    ignored=0   
loadbalancer-1             : ok=18   changed=12   unreachable=0    failed=0    skipped=12   rescued=0    ignored=0   
```
</details>

#### Выводы:

<details>
<summary>Проверка работы</summary>

### Инфрасруктура запущена

![alt-текст](/lesson-5/img/img-1-start.png "1")


### По адресу балансировщика доступен backend

![alt-текст](/lesson-5/img/img-2-access1.png "2")

### Останавливаем один backend

![alt-текст](/lesson-5/img/img-3-bstop.png "3")


### сайт по прежнему доступен, база данных доступна.

![alt-текст](/lesson-5/img/img-4-access-data.png "4")

</details>

##### Инфраструктура собралась, балансировщик работает
