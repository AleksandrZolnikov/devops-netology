#  Домашнее задание к занятию "14.2 Синхронизация секретов с внешними сервисами. Vault"

##  Задача 1: Работа с модулем Vault

- kubectl apply -f 14.2/vault-pod.yml
```
root@node1:~/14-2# kubectl apply -f vault-pod.yml
pod/14.2-netology-vault created
```
- apt install jq
- kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
```
root@node1:~/14-2# kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
[{"ip":"10.233.105.47"}]
```
- kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```
root@node1:~/14-2# kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.1# dnf -y install pip
Fedora 35 - x86_64                                                                                                                                                  6.8 MB/s |  79 MB     00:11
Fedora 35 openh264 (From Cisco) - x86_64                                                                                                                            1.7 kB/s | 2.5 kB     00:01
Fedora Modular 35 - x86_64                                                                                                                                          2.4 MB/s | 3.3 MB     00:01
Fedora 35 - x86_64 - Updates                                                                                                                                        5.7 MB/s |  29 MB     00:05
Fedora Modular 35 - x86_64 - Updates                                                                                                                                1.7 MB/s | 2.9 MB     00:01
Dependencies resolved.
====================================================================================================================================================================================================
 Package                                               Architecture                              Version                                           Repository                                  Size
====================================================================================================================================================================================================
Installing:
 python3-pip                                           noarch                                    21.2.3-4.fc35                                     updates                                    1.8 M
Installing weak dependencies:
 libxcrypt-compat                                      x86_64                                    4.4.28-1.fc35                                     updates                                     89 k
 python3-setuptools                                    noarch                                    57.4.0-1.fc35                                     fedora                                     928 k

Transaction Summary
====================================================================================================================================================================================================
Install  3 Packages

Total download size: 2.8 M
Installed size: 14 M
Downloading Packages:
(1/3): libxcrypt-compat-4.4.28-1.fc35.x86_64.rpm                                                                                                                    276 kB/s |  89 kB     00:00
(2/3): python3-pip-21.2.3-4.fc35.noarch.rpm                                                                                                                         1.8 MB/s | 1.8 MB     00:00
(3/3): python3-setuptools-57.4.0-1.fc35.noarch.rpm                                                                                                                  891 kB/s | 928 kB     00:01
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                               1.3 MB/s | 2.8 MB     00:02
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                            1/1
  Installing       : libxcrypt-compat-4.4.28-1.fc35.x86_64                                                                                                                                      1/3
  Installing       : python3-setuptools-57.4.0-1.fc35.noarch                                                                                                                                    2/3
  Installing       : python3-pip-21.2.3-4.fc35.noarch                                                                                                                                           3/3
  Running scriptlet: python3-pip-21.2.3-4.fc35.noarch                                                                                                                                           3/3
  Verifying        : python3-setuptools-57.4.0-1.fc35.noarch                                                                                                                                    1/3
  Verifying        : libxcrypt-compat-4.4.28-1.fc35.x86_64                                                                                                                                      2/3
  Verifying        : python3-pip-21.2.3-4.fc35.noarch                                                                                                                                           3/3

Installed:
  libxcrypt-compat-4.4.28-1.fc35.x86_64                             python3-pip-21.2.3-4.fc35.noarch                             python3-setuptools-57.4.0-1.fc35.noarch

Complete!
sh-5.1# pip install hvac
Collecting hvac
  Downloading hvac-0.11.2-py2.py3-none-any.whl (148 kB)
     |████████████████████████████████| 148 kB 5.6 MB/s
Collecting six>=1.5.0
  Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
Collecting requests>=2.21.0
  Downloading requests-2.27.1-py2.py3-none-any.whl (63 kB)
     |████████████████████████████████| 63 kB 198 kB/s
Collecting charset-normalizer~=2.0.0
  Downloading charset_normalizer-2.0.12-py3-none-any.whl (39 kB)
Collecting idna<4,>=2.5
  Downloading idna-3.3-py3-none-any.whl (61 kB)
     |████████████████████████████████| 61 kB 480 kB/s
Collecting certifi>=2017.4.17
  Downloading certifi-2021.10.8-py2.py3-none-any.whl (149 kB)
     |████████████████████████████████| 149 kB 14.0 MB/s
Collecting urllib3<1.27,>=1.21.1
  Downloading urllib3-1.26.9-py2.py3-none-any.whl (138 kB)
     |████████████████████████████████| 138 kB 13.9 MB/s
Installing collected packages: urllib3, idna, charset-normalizer, certifi, six, requests, hvac
Successfully installed certifi-2021.10.8 charset-normalizer-2.0.12 hvac-0.11.2 idna-3.3 requests-2.27.1 six-1.16.0 urllib3-1.26.9
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
>>> import hvac
>>> client = hvac.Client(
...     url='http://10.233.105.47:8200',
...     token='aiphohTaa0eeHei'
... )
>>> client.is_authenticated()
True
>>>
>>> client.secrets.kv.v2.create_or_update_secret(
...     path='hvac',
...     secret=dict(netology='Big secret!!!'),
... )
{'request_id': '37b545ff-794d-2827-8dce-c81da2eb0dea', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-08-09T17:48:41.658875357Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 2}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> client.secrets.kv.v2.read_secret_version(
...     path='hvac',
... )
{'request_id': '98806334-8653-b93b-a65b-b24afa574843', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2022-08-09T17:48:41.658875357Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 2}}, 'wrap_info': None, 'warnings': None, 'auth': None}
```

##  Задача 2 (*): Работа с секретами внутри модуля

Создаем deployment:  
```bash
aleksandr@WS01:~/seсrets-vault$ kubectl create deployment hw142 --image=fedora -- sleep 100000
deployment.apps/hw142 created

```
Создаем секрет:  
```bash
aleksandr@WS01:~/seсrets-vault$ kubectl create secret generic mytoken --from-literal=vault_token=aiphohTaa0eeHei
secret/mytoken created

```

Присоединяем секрет к поду:  
```bash
aleksandr@WS01:~/seсrets-vault$ kubectl set env --from=secret/mytoken deployment/hw142
deployment.apps/hw142 env updated

```
Добавляем в переменные окружения адрес vault:  
```bash
aleksandr@WS01:~/seсrets-vault$ kubectl set env deployment/hw142 VAULT_ADDR=http://172.17.0.3:8200
deployment.apps/hw142 env updated
```

Проваливаемся в под:  
```bash
aleksandr@WS01:~/seсrets-vault$ kubectl get po
NAME                     READY   STATUS      RESTARTS   AGE
14.2-netology-vault      1/1     Running     0          39m
fedora                   0/1     Completed   0          36m
hw142-54f6cbdc6c-j2zjg   1/1     Running     0          91s
aleksandr@WS01:~/seсrets-vault$ kubectl exec -ti hw142-54f6cbdc6c-j2zjg -c fedora -- /bin/sh
sh-5.1# 

```
Устанавливаем зависимости:  
```bash
dnf -y install pip
pip install hvac
```

```bash
sh-5.1# /usr/bin/python3
Python 3.10.2 (main, Jan 17 2022, 00:00:00) [GCC 11.2.1 20211203 (Red Hat 11.2.1-7)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import hvac
>>> import os
>>> client = hvac.Client(
...     url=os.environ.get('VAULT_ADDR'),
...     token=os.environ.get('VAULT_TOKEN')
... )
>>> client.is_authenticated()
True
>>> 
>>> client.secrets.kv.v2.create_or_update_secret(
...     path='hvac_new',
...     secret=dict(hw142='Very Big Super secret!!!'),
... )
{'request_id': '7e1e09cc-9b05-0b0e-12a9-70de241b54ed', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-08-09T18:57:54.496305564Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> 
>>> client.secrets.kv.v2.read_secret_version(
...     path='hvac_new',
... )
{'request_id': '86d9738d-24c7-ddb4-37f0-cf99a5635bdf', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'hw142': 'Very Big Super secret!!!'}, 'metadata': {'created_time': '2022-08-09T18:57:54.496305564Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> 

```
![screen](https://github.com/AleksandrZolnikov/devops-netology/blob/main/virt-homeworks/14.02-kube-seсrets-vault/Screenshot_1.png)
