# Домашнее задание к занятию "13.4 инструменты для упрощения написания конфигурационных файлов. Helm и Jsonnet"
В работе часто приходится применять системы автоматической генерации конфигураций. Для изучения нюансов использования разных инструментов нужно попробовать упаковать приложение каждым из них.

## Задание 1: подготовить helm чарт для приложения
Необходимо упаковать приложение в чарт для деплоя в разные окружения. Требования:
* каждый компонент приложения деплоится отдельным deployment’ом/statefulset’ом;
* в переменных чарта измените образ приложения для изменения версии.

## Задание 2: запустить 2 версии в разных неймспейсах
Подготовив чарт, необходимо его проверить. Попробуйте запустить несколько копий приложения:
* одну версию в namespace=app1;
* вторую версию в том же неймспейсе;
* третью версию в namespace=app2.
---

## Подготовка

Создаем 2 неймспейса:

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: app1

---
apiVersion: v1
kind: Namespace
metadata:
  name: app2
```

```bash
$ kubectl apply -f namespaces.yml
$ kubectl get namespaces --show-labels
NAME                   STATUS   AGE     LABELS
app1                   Active   3m18s   kubernetes.io/metadata.name=app1
app2                   Active   3m18s   kubernetes.io/metadata.name=app2
default                Active   38m     kubernetes.io/metadata.name=default
kube-node-lease        Active   38m     kubernetes.io/metadata.name=kube-node-lease
kube-public            Active   38m     kubernetes.io/metadata.name=kube-public
kube-system            Active   38m     kubernetes.io/metadata.name=kube-system
kubernetes-dashboard   Active   38m     kubernetes.io/metadata.name=kubernetes-dashboard

```

# Решение

## Задание 1: подготовить helm чарт для приложения

### [Helm chart]()

## Задание 2: запустить 2 версии в разных неймспейсах

```bash
$ helm install helm-app-v1 my-chart/ --set namespace=app1
NAME: helm-app-v1
LAST DEPLOYED: Thu July 14 23:14:23 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
$ helm install helm-app-v2 my-chart/ --set namespace=app1,image.tag.backend=v2
NAME: helm-app-v2
LAST DEPLOYED:Thu July 14 23:14:43 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
$ helm install helm-app-v3 my-chart/ --set namespace=app2,image.tag.postgres=latest,replicaCount.frontend=1,replicaCount.backend=1
NAME: helm-app-v3
LAST DEPLOYED: Thu July 14 23:19:21 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
$ helm list
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
helm-app-v1     default         1               2022-07-14 23:14:23.129961999 +0600 +06 deployed        helm-chart-0.1.0        1.0.0      
helm-app-v2     default         1               2022-07-14 23:14:43.487629669 +0600 +06 deployed        helm-chart-0.1.0        1.0.0      
helm-app-v3     default         1               2022-07-14 23:19:21.918988489 +0600 +06 deployed        helm-chart-0.1.0        1.0.0
$ kubectl get po,sts,svc -n app1
NAME                                     READY   STATUS    RESTARTS   AGE
pod/helm-app-v1-back-6948f988fc-gz829    1/1     Running   0          10m
pod/helm-app-v1-back-6948f988fc-kvp56    1/1     Running   0          10m
pod/helm-app-v1-db-0                     1/1     Running   0          10m
pod/helm-app-v1-front-65869b85df-ctxx6   1/1     Running   0          10m
pod/helm-app-v1-front-65869b85df-z8jjz   1/1     Running   0          10m
pod/helm-app-v2-back-b5d9bcd48-dsglt     1/1     Running   0          11m
pod/helm-app-v2-back-b5d9bcd48-rl89p     1/1     Running   0          11m
pod/helm-app-v2-db-0                     1/1     Running   0          11m
pod/helm-app-v2-front-65869b85df-5l7v7   1/1     Running   0          11m
pod/helm-app-v2-front-65869b85df-wfzh5   1/1     Running   0          11m

NAME                              READY   AGE
statefulset.apps/helm-app-v1-db   1/1     10m
statefulset.apps/helm-app-v2-db   1/1     11m

NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/helm-app-v1-back-svc    ClusterIP   10.99.71.172     <none>        9000/TCP   10m
service/helm-app-v1-db-svc      ClusterIP   10.106.166.111   <none>        5432/TCP   10m
service/helm-app-v1-front-svc   ClusterIP   10.97.185.64     <none>        8000/TCP   10m
service/helm-app-v2-back-svc    ClusterIP   10.102.61.229    <none>        9000/TCP   11m
service/helm-app-v2-db-svc      ClusterIP   10.98.122.69     <none>        5432/TCP   11m
service/helm-app-v2-front-svc   ClusterIP   10.99.51.62      <none>        8000/TCP   11m
$ kubectl get po,sts,svc -n app2
NAME                                     READY   STATUS    RESTARTS   AGE
pod/helm-app-v3-back-6948f988fc-sl8z9    1/1     Running   0          2m52s
pod/helm-app-v3-db-0                     1/1     Running   0          2m52s
pod/helm-app-v3-front-65869b85df-4fcv7   1/1     Running   0          2m52s

NAME                              READY   AGE
statefulset.apps/helm-app-v3-db   1/1     2m52s

NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/helm-app-v3-back-svc    ClusterIP   10.103.5.50      <none>        9000/TCP   2m52s
service/helm-app-v3-db-svc      ClusterIP   10.100.182.201   <none>        5432/TCP   2m52s
service/helm-app-v3-front-svc   ClusterIP   10.108.80.214    <none>        8000/TCP   2m52s
```