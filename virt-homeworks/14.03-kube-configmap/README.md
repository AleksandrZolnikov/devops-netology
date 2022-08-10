### Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube. 

Как создать карту конфигураций?  
```
aleksandr@WS01:~/14.03-kube-configmap$ kubectl create configmap nginx-config --from-file=nginx.conf
configmap/nginx-config created
aleksandr@WS01:~/14.03-kube-configmap$ kubectl create configmap domain --from-literal=name=netology.ru
configmap/domain created
```

Как просмотреть список карт конфигураций?  
```
aleksandr@WS01:~/14.03-kube-configmap$ kubectl get configmaps
NAME               DATA   AGE
domain             1      10s
kube-root-ca.crt   1      78m
nginx-config       1      78s
```

Как просмотреть карту конфигурации?  
```
aleksandr@WS01:~/14.03-kube-configmap$ kubectl get configmap nginx-config
NAME           DATA   AGE
nginx-config   1      3m01s
aleksandr@WS01:~/14.03-kube-configmap$ kubectl describe configmap domain       
Name:         domain
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
name:
----
netology.ru

BinaryData
====

Events:  <none>
```

Как получить информацию в формате YAML и/или JSON?  
Часть вывода обрезал  
```
aleksandr@WS01:~/14.03-kube-configmap$ kubectl get configmap nginx-config -o yaml
apiVersion: v1
data:
  nginx.conf: |
    server {
        listen 80;
        server_name  netology.ru www.netology.ru;
        access_log  /var/log/nginx/domains/netology.ru-access.log  main;
        error_log   /var/log/nginx/domains/netology.ru-error.log info;
        location / {
            include proxy_params;
            proxy_pass http://10.10.10.10:8080/;

aleksandr@WS01:~/14.03-kube-configmap$ kubectl get configmap domain -o json
{
    "apiVersion": "v1",
    "data": {
        "name": "netology.ru"
    },
    "kind": "ConfigMap",
    "metadata": {
        "creationTimestamp": "2022-08-10T19:02:51Z",
        "name": "domain",
        "namespace": "default",
        "resourceVersion": "12669",
        "uid": "2aa82763-1a12-49d4-8632-bb51edfe9445"
    }
}
```

Как выгрузить карту конфигурации и сохранить его в файл?  
Часть вывода обрезал  
```
aleksandr@WS01:~/14.03-kube-configmap$ kubectl get configmaps -o json > configmaps.json
aleksandr@WS01:~/14.03-kube-configmap$ cat configmaps.json 
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "data": {
                "name": "netology.ru"
            },
            "kind": "ConfigMap",
            "metadata": {
                "creationTimestamp": "2022-08-10T19:02:51Z",
                "name": "domain",
                "namespace": "default",
                "resourceVersion": "12669",
                "uid": "2aa82763-1a12-49d4-8632-bb51edfe9445"
            }
        },

aleksandr@WS01:~/14.03-kube-configmap$ kubectl get configmap nginx-config -o yaml > nginx-config.yml
```

Как удалить карту конфигурации?  
```
aleksandr@WS01:~/14.03-kube-configmap$ kubectl delete configmap nginx-config
configmap "nginx-config" deleted
```

Как загрузить карту конфигурации из файла?  
```
aleksandr@WS01:~/14.03-kube-configmap$ kubectl apply -f nginx-config.yml
configmap/nginx-config created
```

### Задача 2 (*): Работа с картами конфигураций внутри модуля  

Выбрать любимый образ контейнера, подключить карты конфигураций и проверить их  доступность как в виде переменных окружения, так и в виде примонтированного тома  

Сделал yml для развертывания с образом федоры:  
```
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: configmap1
data:
  task1: test1
  task2: test2
  task3: test3

---
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
    - name: fedora
      image: fedora
      command: [ "/bin/sh", "-c", "sleep 3600" ]
      env:
        - name: TASK_1
          valueFrom:
            configMapKeyRef:
              name: configmap1
              key: task1
        - name: TASK_2
          valueFrom:
            configMapKeyRef:
              name: configmap1
              key: task2
      volumeMounts:
      - name: configmap1-volume
        mountPath: /etc/config/
  volumes:
  - name: configmap1-volume
    configMap:
      name: configmap1
  restartPolicy: Never
```

Процесс:  
```
aleksandr@WS01:~/14.03-kube-configmap$ kubectl get po
No resources found in default namespace.
aleksandr@WS01:~/14.03-kube-configmap$ kubectl apply -f pods.yml
configmap/configmap1 created
pod/test-pod created
aleksandr@WS01:~/14.03-kube-configmap$ kubectl get po
NAME       READY   STATUS    RESTARTS   AGE
test-pod   1/1     Running   0          7s
```

Проверяем переменные:  
```
aleksandr@WS01:~/14.03-kube-configmap$ kubectl exec -ti test-pod -c fedora -- env | grep TASK_1
TASK_1=test1
aleksandr@WS01:~/14.03-kube-configmap$ kubectl exec -ti test-pod -c fedora -- env | grep TASK_2
TASK_2=test2
```

Проверяем примонтированный диск:  
```
aleksandr@WS01:~/14.03-kube-configmap$ kubectl exec -ti test-pod -c fedora -- ls -al /etc/config
total 0
drwxrwxrwx. 3 root root 99 Aug  1 19:13 .
drwxr-xr-x. 1 root root 25 Aug  1 19:13 ..
drwxr-xr-x. 2 root root 45 Aug  1 19:13 ..2022_04_01_19_13_43.3727146560
lrwxrwxrwx. 1 root root 29 Aug  1 19:13 ..data -> ..2022_04_01_19_13_43.3727146560
lrwxrwxrwx. 1 root root 10 Aug  1 19:13 task1 -> ..data/task1
lrwxrwxrwx. 1 root root 10 Aug  1 19:13 task2 -> ..data/task2
lrwxrwxrwx. 1 root root 10 Aug  1 19:13 task3 -> ..data/task3
aleksandr@WS01:~/14.03-kube-configmap$ kubectl exec -ti test-pod -c fedora -- cat /etc/config/task1
test1
aleksandr@WS01:~/14.03-kube-configmap$ kubectl exec -ti test-pod -c fedora -- cat /etc/config/task2
test2
```
