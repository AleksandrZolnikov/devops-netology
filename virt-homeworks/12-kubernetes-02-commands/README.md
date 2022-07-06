## Домашнее задание к занятию "12.2 Команды для работы с Kubernetes"
Кластер — это сложная система, с которой крайне редко работает один человек. Квалифицированный devops умеет наладить работу всей команды, занимающейся каким-либо сервисом.
После знакомства с кластером вас попросили выдать доступ нескольким разработчикам. Помимо этого требуется служебный аккаунт для просмотра логов.

### Задание 1: Запуск пода из образа в деплойменте
Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. Сразу стоит запустить 2 копии приложения (replicas=2). 

Требования:
 * пример из hello world запущен в качестве deployment
 * количество реплик в deployment установлено в 2
 * наличие deployment можно проверить командой kubectl get deployment
 * наличие подов можно проверить командой kubectl get pods  
 
### Ответ:  
```
kubectl create deploy app-deploy --image=k8s.gcr.io/echoserver:1.4 --replicas=2
``` 
```
root@minicube:~# kubectl create deploy app-deploy --image=k8s.gcr.io/echoserver:1.4 --replicas=2
deployment.apps/app-deploy created
root@minicube:~# kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
app-deploy-8c989567-62luk   1/1     Running   0          10s
app-deploy-8c989567-n68hs   1/1     Running   0          10s
```

### Задание 2: Просмотр логов для разработки
Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе. 
Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования: 
 * создан новый токен доступа для пользователя
 * пользователь прописан в локальный конфиг (~/.kube/config, блок users)
 * пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)

### Ответ:  

```
root@minicube:~# kubectl create ns app-namespace
```

```
root@minicube:~# kubectl create deploy app-deploy --image=k8s.gcr.io/echoserver:1.4 --namespace=app-namespace --replicas=2
```

```
root@minicube:~# kubectl create serviceaccount viewpodslog
```

```
root@minicube:~# kubectl create clusterrole viewpodslog --verb=get --verb=list --verb=watch --resource=pods --resource=pods/log
```

```
root@minicube:~# kubectl create rolebinding viewpodslog --serviceaccount=default:viewpodslog --clusterrole=viewpodslog -n app-namespace
```

```
root@minicube:~# kubectl config set-credentials aleksandr --token=$(kubectl describe secrets "$(kubectl describe serviceaccount viewpodslog | grep -i Tokens | awk '{print $2}')" | grep token: | awk '{print $2}')
```

```
root@minicube:~# kubectl config set-context applogs --cluster=minikube --user=aleksandr
```

```
root@minicube:~# kubectl config use-context applogs
```

```
root@minicube:~# kubectl create ns app-namespace
namespace/app-namespace created
```

```
root@minicube:~# kubectl create deploy app-deploy --image=k8s.gcr.io/echoserver:1.4 --namespace=app-namespace --replicas=2
deployment.apps/app-deploy created
```

```
root@minicube:~# kubectl create serviceaccount viewpodslog
serviceaccount/viewpodslog created
```

```
root@minicube:~# kubectl create clusterrole viewpodslog --verb=get --verb=list --verb=watch --resource=pods --resource=pods/log
clusterrole.rbac.authorization.k8s.io/viewpodslog created
```

```
root@minicube:~# kubectl create rolebinding viewpodslog --serviceaccount=default:viewpodslog --clusterrole=viewpodslog -n app-namespace
rolebinding.rbac.authorization.k8s.io/viewpodslog created
```

```
root@minicube:~# kubectl config set-credentials aleksandr --token=$(kubectl describe secrets "$(kubectl describe serviceaccount viewpodslog | grep -i Tokens | awk '{print $2}')" | grep token: | awk '{print $2}')
User "aleksandr" set.
root@minicube:~# kubectl config set-context applogs --cluster=minikube --user=aleksandr
Context "applogs" created.
root@minicube:~# kubectl config use-context applogs
Switched to context "applogs".
root@minicube:~# kubectl get pods
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:default:viewpodslog" cannot list resource "pods" in API group "" in the namespace "default"
root@minicube:~# kubectl get pods -n app-namespace
NAME                        READY   STATUS    RESTARTS   AGE
app-deploy-9b975845-f2wsg   1/1     Running   0          79s
app-deploy-9b975845-zvn25   1/1     Running   0          79s
root@minicube:~# kubectl logs app-deploy-8c989567-f2wsg
Error from server (Forbidden): pods "app-deploy-8c989567-f2wsg" is forbidden: User "system:serviceaccount:default:viewpodslog" cannot get resource "pods" in API group "" in the namespace "default"
root@minicube:~# kubectl logs app-deploy-8c989567-f2wsg -n app-namespace
root@minicube:~# kubectl logs -f app-deploy-8c989567-f2wsg -n app-namespace

```

### Задание 3: Изменение количества реплик 
Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения реплик. 

Требования:
 * в deployment из задания 1 изменено количество реплик на 5
 * проверить что все поды перешли в статус running (kubectl get pods)
 
 ### Ответ:  
 ```
 kubectl scale deploy app-deploy --replicas=5
 ```
 Процесс:  
 ```
root@minicube:~# kubectl scale deploy app-deploy --replicas=5
deployment.apps/app-deploy scaled
root@minicube:~# kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
app-deploy-8c989567-92tpk   1/1     Running   0          1m39s
app-deploy-8c989567-9ckhz   1/1     Running   0          5s
app-deploy-8c989567-d66q2   1/1     Running   0          5s
app-deploy-8c989567-n88hs   1/1     Running   0          1m39s
app-deploy-8c989567-ppbc7   1/1     Running   0          5s
```
