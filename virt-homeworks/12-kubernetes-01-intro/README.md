#  Домашнее задание к занятию "12.1 Компоненты Kubernetes"

##  Задача 1: Установить Minikube

```
root@minicube:~# minikube version
minikube version: v1.24.0
```

```
root@minicube:~# minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

```
root@minicube:~# kubectl get pods --namespace=kube-system
NAME                               READY   STATUS    RESTARTS   AGE
coredns-89ghd78956-nshmh           1/1     Running   0          3m11s
etcd-minicube                      1/1     Running   0          3m16s
kube-apiserver-minicube            1/1     Running   0          3m17s
kube-controller-manager-minicube   1/1     Running   0          3m55s
kube-proxy-kspk6                   1/1     Running   0          3m57s
kube-scheduler-minicube            1/1     Running   0          3m59s
storage-provisioner                1/1     Running   0          3m59s
```

##  Задача 2: Запуск Hello World

```
root@minicube:~# kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   1/1     1            1           84s
root@minicube:~# kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6457d9ytj1-6rfg3   1/1     Running   0          65s
```

```
root@minicube:~# minikube addons list
|-----------------------------|----------|--------------|-----------------------|
|         ADDON NAME          | PROFILE  |    STATUS    |      MAINTAINER       |
|-----------------------------|----------|--------------|-----------------------|
| ambassador                  | minikube | disabled     | unknown (third-party) |
| auto-pause                  | minikube | disabled     | google                |
| csi-hostpath-driver         | minikube | disabled     | kubernetes            |
| dashboard                   | minikube | disabled     | kubernetes            |
| default-storageclass        | minikube | enabled ✅   | kubernetes            |
| efk                         | minikube | disabled     | unknown (third-party) |
| freshpod                    | minikube | disabled     | google                |
| gcp-auth                    | minikube | disabled     | google                |
| gvisor                      | minikube | disabled     | google                |
| helm-tiller                 | minikube | disabled     | unknown (third-party) |
| ingress                     | minikube | disabled     | unknown (third-party) |
| ingress-dns                 | minikube | disabled     | unknown (third-party) |
| istio                       | minikube | disabled     | unknown (third-party) |
| istio-provisioner           | minikube | disabled     | unknown (third-party) |
| kubevirt                    | minikube | disabled     | unknown (third-party) |
| logviewer                   | minikube | disabled     | google                |
| metallb                     | minikube | disabled     | unknown (third-party) |
| metrics-server              | minikube | disabled     | kubernetes            |
| nvidia-driver-installer     | minikube | disabled     | google                |
| nvidia-gpu-device-plugin    | minikube | disabled     | unknown (third-party) |
| olm                         | minikube | disabled     | unknown (third-party) |
| pod-security-policy         | minikube | disabled     | unknown (third-party) |
| portainer                   | minikube | disabled     | portainer.io          |
| registry                    | minikube | disabled     | google                |
| registry-aliases            | minikube | disabled     | unknown (third-party) |
| registry-creds              | minikube | disabled     | unknown (third-party) |
| storage-provisioner         | minikube | enabled ✅   | kubernetes            |
| storage-provisioner-gluster | minikube | disabled     | unknown (third-party) |
| volumesnapshots             | minikube | disabled     | kubernetes            |
|-----------------------------|----------|--------------|-----------------------|
```

```
root@minicube:~# minikube addons enable ingress
  - Using image k8s.gcr.io/ingress-nginx/controller:v1.0.4
  - Using image k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
  - Using image k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
* Verifying ingress addon...
* The 'ingress' addon is enabled
root@minicube:~# minikube addons enable dashboard
  - Using image kubernetesui/dashboard:v2.3.1
  - Using image kubernetesui/metrics-scraper:v1.0.7
* Some dashboard features require the metrics-server addon. To enable all features please run:

        minikube addons enable metrics-server


* The 'dashboard' addon is enabled
```

```
root@minicube:~# minikube addons list
|-----------------------------|----------|--------------|-----------------------|
|         ADDON NAME          | PROFILE  |    STATUS    |      MAINTAINER       |
|-----------------------------|----------|--------------|-----------------------|
| ambassador                  | minikube | disabled     | unknown (third-party) |
| auto-pause                  | minikube | disabled     | google                |
| csi-hostpath-driver         | minikube | disabled     | kubernetes            |
| dashboard                   | minikube | enabled ✅   | kubernetes            |
| default-storageclass        | minikube | enabled ✅   | kubernetes            |
| efk                         | minikube | disabled     | unknown (third-party) |
| freshpod                    | minikube | disabled     | google                |
| gcp-auth                    | minikube | disabled     | google                |
| gvisor                      | minikube | disabled     | google                |
| helm-tiller                 | minikube | disabled     | unknown (third-party) |
| ingress                     | minikube | enabled ✅   | unknown (third-party) |
| ingress-dns                 | minikube | disabled     | unknown (third-party) |
| istio                       | minikube | disabled     | unknown (third-party) |
| istio-provisioner           | minikube | disabled     | unknown (third-party) |
| kubevirt                    | minikube | disabled     | unknown (third-party) |
| logviewer                   | minikube | disabled     | google                |
| metallb                     | minikube | disabled     | unknown (third-party) |
| metrics-server              | minikube | disabled     | kubernetes            |
| nvidia-driver-installer     | minikube | disabled     | google                |
| nvidia-gpu-device-plugin    | minikube | disabled     | unknown (third-party) |
| olm                         | minikube | disabled     | unknown (third-party) |
| pod-security-policy         | minikube | disabled     | unknown (third-party) |
| portainer                   | minikube | disabled     | portainer.io          |
| registry                    | minikube | disabled     | google                |
| registry-aliases            | minikube | disabled     | unknown (third-party) |
| registry-creds              | minikube | disabled     | unknown (third-party) |
| storage-provisioner         | minikube | enabled ✅   | kubernetes            |
| storage-provisioner-gluster | minikube | disabled     | unknown (third-party) |
| volumesnapshots             | minikube | disabled     | kubernetes            |
|-----------------------------|----------|--------------|-----------------------|
```

```
root@minicube:~# kubectl get pod -n kube-system
NAME                                   READY   STATUS    RESTARTS   AGE
coredns-89ghd78956-79t9b           1/1     Running   0          12m
etcd-minicube                      1/1     Running   1          12m
kube-apiserver-minicube            1/1     Running   1          12m
kube-controller-manager-minicube   1/1     Running   1          12m
kube-proxy-z3f2x                   1/1     Running   0          11m
kube-scheduler-minicube            1/1     Running   1          12m
storage-provisioner                1/1     Running   0          12m

NAME               TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
service/kube-dns   ClusterIP   10.45.0.10   <none>        53/UDP,53/TCP,9153/TCP   19m
root@minicube:~# kubectl expose deployment hello-node --type=LoadBalancer --port=8080
service/hello-node exposed
root@minicube:~# kubectl get services
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
hello-node   LoadBalancer   10.45.172.149   <pending>     8080:31750/TCP   20s
kubernetes   ClusterIP      10.45.0.1       <none>        443/TCP          43m
```

##  Задача 3: Установить kubectl


Проверяем доступность сервиса с рабочей машины

```
root@docker:~# curl http://192.172.1.26:31750
CLIENT VALUES:
client_address=172.17.0.1
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://192.172.1.26:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=192.172.1.26:31750
user-agent=curl/7.68.0
BODY:
```

Устанавливаем kubectl на рабочую машину

```
root@docker:~# curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 44.4M  100 44.4M    0     0  3121k      0  0:00:19  0:00:19 --:--:-- 3121k
root@docker:~# chmod +x ./kubectl
root@docker:~# mv ./kubectl /usr/local/bin/kubectl

```
Проверка

```
root@docker:~# kubectl get pods --namespace=kube-system
NAME                               READY   STATUS    RESTARTS   AGE
coredns-78fcd69978-79t9b           1/1     Running   0          59m
etcd-minicube                      1/1     Running   1          59m
kube-apiserver-minicube            1/1     Running   1          59m
kube-controller-manager-minicube   1/1     Running   1          59m
kube-proxy-n2j7x                   1/1     Running   0          58m
kube-scheduler-minicube            1/1     Running   1          59m
storage-provisioner                1/1     Running   0          58m
```
```
root@docker:~# kubectl get services
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
hello-node   LoadBalancer   10.45.172.149   <pending>     8080:31750/TCP   59m
kubernetes   ClusterIP      10.45.0.1       <none>        443/TCP          103m
root@docker:~# kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   1/1     1            1           51
```
