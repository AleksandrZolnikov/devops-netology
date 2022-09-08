## Домашнее задание к занятию "14.5 SecurityContext, NetworkPolicies"

### Задача 1: Рассмотрите пример 14.5/example-security-context.yml

Создайте модуль

```bash
kubectl apply -f 14.5/example-security-context.yml
```

Проверьте установленные настройки внутри контейнера

```bash
kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```

Процесс:
```bash
aleksandr@WS01:~/14.05-securitycontext$ kubectl apply -f 14.5/example-security-context.yml
pod/security-context-demo created
aleksandr@WS01:~/14.05-securitycontext$ kubectl get pod
NAME                    READY   STATUS              RESTARTS   AGE
security-context-demo   0/1     ContainerCreating   0          7s
aleksandr@WS01:~/14.05-securitycontext$ kubectl get pod
NAME                    READY   STATUS      RESTARTS     AGE
security-context-demo   0/1     Completed   1 (3s ago)   14s
aleksandr@WS01:~/14.05-securitycontext$ kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
aleksandr@WS01:~/14.05-securitycontext$
```

### Задача 2 (*): Рассмотрите пример 14.5/example-network-policy.yml

Создайте два модуля. Для первого модуля разрешите доступ к внешнему миру
и ко второму контейнеру. Для второго модуля разрешите связь только с
первым контейнером. Проверьте корректность настроек.

Запустил два пода:
```bash
aleksandr@WS01:~/14.05-securitycontext$ kubectl run pod1 --image=nginx --labels='app=dev,number=first'
pod/pod1 created
aleksandr@WS01:~/14.05-securitycontext$ kubectl run pod2 --image=nginx --labels='app=dev,number=second'
pod/pod2 created
```

Манифест с политикой:
```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: dev-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: dev
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: dev
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: dev
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: dev-network-policy-outspace
  namespace: default
spec:
  podSelector:
    matchLabels:
      number: first
  ingress:
  - {}
  egress:
  - {}
```
Применяем манифест:
```bash
aleksandr@WS01:~/14.05-securitycontext$ kubectl apply -f netpol.yaml
networkpolicy.networking.k8s.io/dev-network-policy created
networkpolicy.networking.k8s.io/dev-network-policy-outspace created 
```
Просмотр подов:
```bash
aleksandr@WS01:~/14.05-securitycontext$ kubectl get pods -o wide
NAME                    READY   STATUS             RESTARTS         AGE     IP             NODE    NOMINATED NODE   READINESS GATES
pod1                    1/1     Running            0                10m     10.233.90.3    node1   <none>           <none>
pod2                    1/1     Running            0                10m     10.233.92.3    node3   <none>           <none>
```
Проверяем
```bash
aleksandr@WS01:~/14.05-securitycontext$ kubectl exec -ti pod1 -- /bin/bash
root@pod1:/# curl -X GET "https://httpbin.org/get"
{
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.org",
    "User-Agent": "curl/7.74.0",
    "X-Amzn-Trace-Id": "Root=1-624c9cf0-499f9ab822e3196a683061ed"
  },
  "origin": "51.250.78.57",
  "url": "https://httpbin.org/get"
}
root@pod1:/# curl -X GET http://10.233.92.3
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
root@pod1:/# exit
exit
```
Зашел на второй под, проверил:
```bash
aleksandr@WS01:~/14.05-securitycontext$ kubectl exec -ti pod2 -- /bin/bash
root@pod2:/# curl -X GET "https://httpbin.org/get"
curl: (6) Could not resolve host: httpbin.org
root@pod2:/# curl -X GET http://10.233.90.3
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
root@pod2:/#
```
