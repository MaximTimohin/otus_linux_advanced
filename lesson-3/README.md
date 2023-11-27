#### GFS2 хранилищt в Yandex Cloud + terraform.
###  




##### Цель:

* Реализовать GFS2 хранилище на виртуалках Yandex Cloud помощью terraform.


### Настройка:

###### Настраиваем

<details>
<summary>Terraform apply</summary>

#### Заммустим создание инфраструктуры
```
yandex_compute_instance.storage (local-exec): TASK [Mount FS] ****************************************************************
yandex_compute_instance.storage (local-exec): skipping: [178.154.206.85]
yandex_compute_instance.storage (local-exec): skipping: [178.154.207.25]
yandex_compute_instance.storage (local-exec): changed: [178.154.200.118]

yandex_compute_instance.storage (local-exec): PLAY RECAP *********************************************************************
yandex_compute_instance.storage (local-exec): 178.154.200.118            : ok=37   changed=33   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
yandex_compute_instance.storage (local-exec): 178.154.201.180            : ok=4    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
yandex_compute_instance.storage (local-exec): 178.154.206.85             : ok=23   changed=19   unreachable=0    failed=0    skipped=14   rescued=0    ignored=0
yandex_compute_instance.storage (local-exec): 178.154.207.25             : ok=23   changed=19   unreachable=0    failed=0    skipped=14   rescued=0    ignored=0

yandex_compute_instance.storage: Creation complete after 3m13s [id=fhm286jsegbt5kcft4pg]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```


#### Инфраструктура собралась

```
ssh -i ../../private/id_rsa maxim@178.154.206.85
[maxim@node-1 ~]$ sudo pcs status
Cluster name: mycluster
Stack: corosync
Current DC: node-1 (version 1.1.23-1.el7_9.1-9acf116022) - partition with quorum
Last updated: Mon Nov 27 12:06:37 2023
Last change: Mon Nov 27 12:05:49 2023 by root via cibadmin on node-0

3 nodes configured
9 resource instances configured

Online: [ node-0 node-1 node-2 ]

Full list of resources:

Clone Set: dlm-clone [dlm]
    Started: [ node-0 node-1 node-2 ]
Clone Set: clvmd-clone [clvmd]
    Started: [ node-0 node-1 node-2 ]
Clone Set: clusterfs-clone [clusterfs]
    Started: [ node-0 node-1 node-2 ]

Daemon Status:
 corosync: active/enabled
 pacemaker: active/enabled
 pcsd: active/enabled
[maxim@node-1 ~]$ df -h
Файловая система                  Размер Использовано  Дост Использовано% Cмонтировано в
devtmpfs                            1,9G            0  1,9G            0% /dev
tmpfs                               1,9G          75M  1,8G            4% /dev/shm
tmpfs                               1,9G         672K  1,9G            1% /run
tmpfs                               1,9G            0  1,9G            0% /sys/fs/cgroup
/dev/vda2                            10G         2,1G  8,0G           21% /
tmpfs                               379M            0  379M            0% /run/user/1001
/dev/mapper/cluster_vg-cluster_lv   900M          37M  864M            5% /mnt/gfs2
```
</details>

<details>
<summary>Тест /mnt/gfs2</summary>


#### Проверим /mnt/gfs2
###### Создадим на одном узле файл в /mnt/gfs2
```
ssh -i ../../private/id_rsa maxim@178.154.206.85
[maxim@node-1 ~]$ sudo -i
[root@node-1 ~]# ls -lsa  /mnt/gfs2/
итого 4
4 drwxr-xr-x. 2 root root 3864 ноя 27 12:20 .
0 drwxr-xr-x. 3 root root   18 ноя 27 12:05 ..
[root@node-1 ~]# echo \"test-LAB-OTUS-Lesson3 - `date`\" >> /mnt/gfs2/public.txt
[root@node-1 ~]# ls -lsa  /mnt/gfs2/
итого 12
4 drwxr-xr-x. 2 root root 3864 ноя 27 12:28 .
0 drwxr-xr-x. 3 root root   18 ноя 27 12:05 ..
8 -rw-r--r--. 1 root root   59 ноя 27 12:28 public.txt

```

###### Проверим на другом узле файл /mnt/gfs2/public.txt

```
ssh -i ../../private/id_rsa maxim@178.154.207.25
[maxim@node-2 ~]$ ls -lsa /mnt/gfs2/public.txt
8 -rw-r--r--. 1 root root 59 ноя 27 12:28 /mnt/gfs2/public.txt
[maxim@node-2 ~]$ cat /mnt/gfs2/public.txt
"test-LAB-OTUS-Lesson3 - Пн ноя 27 12:28:24 UTC 2023"
[maxim@node-2 ~]$
```


</details>

##### Выводы:
Инфраструктура собралась и запустилась. GFS2 работает.
