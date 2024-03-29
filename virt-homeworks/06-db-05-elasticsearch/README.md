## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

**Dockerfile:**
```
FROM centos:centos7

ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.3-linux-x86_64.tar.gz /
ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.3-linux-x86_64.tar.gz.sha512 /

RUN yum check-update && \
    yum install -y perl-Digest-SHA && \
    shasum -a 512 -c elasticsearch-7.9.3-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-7.9.3-linux-x86_64.tar.gz && \
    cd elasticsearch-7.9.3/  && \
    rm -rf /elasticsearch-7.9.3-linux-x86_64.tar.gz /elasticsearch-7.9.3-linux-x86_64.tar.gz.sha512  && \
    useradd elastic  && \
    chown -R elastic /elasticsearch-7.9.3/
ENTRYPOINT ["/elasticsearch-7.9.3/bin/elasticsearch"]
CMD ["-Enode.name=netology_test"]
```
**[Ссылка на образ https://hub.docker.com](https://hub.docker.com/layers/168073459/aleksandrzol/netology/elastic/images/sha256-ad5f116715979f9065d880e9223a3a19eab49e80fe919acffbae3e28d0164ec9?context=repo)**

**Проверка:**
```
aleksandr@aleksandr-VirtualBox:~/netology/05-db$ docker run -di --name elastic --user elastic -p 9200:9200 aleksandrzol/netology:elastic

aleksandr@aleksandr-VirtualBox:~/netology/05-db$ docker exec -it elastic curl localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "RTzJzr5zSKaG7dd-lUlSFA",
  "version" : {
    "number" : "7.9.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "c4138e51121ef06a6404866cddc601906fe5c868",
    "build_date" : "2020-10-16T10:36:16.141335Z",
    "build_snapshot" : false,
    "lucene_version" : "8.6.2",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}

```

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```
[elastic@ee45316f568f /]$ curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 1,  
>       "number_of_replicas": 0 
>     }
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}


[elastic@ee45316f568f /]$ curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 2,  
>       "number_of_replicas": 1 
>     }
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}



[elastic@ee45316f568f /]$ curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 4,  
>       "number_of_replicas": 2 
>     }
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}

```


Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

```
[elastic@ee45316f568f /]$ curl 'localhost:9200/_cat/indices?v'
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 HnQVg5C-R62f22Wtx3jEJQ   1   0          0            0       208b           208b
yellow open   ind-3 W1ktUKR9S3GGaBlNTDP4Kw   4   2          0            0       832b           832b
yellow open   ind-2 8fcZ76yKRWWxBZwq1Ujjdw   2   1          0            0       416b           416b
```

Получите состояние кластера `elasticsearch`, используя API.
```
[elastic@ee45316f568f /]$ curl -XGET 'localhost:9200/_cluster/health?pretty'
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 7,
  "active_shards" : 7,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 41.17647058823529
}
```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
```
В состоянии yellow навходятся индексы ind-2 и ind-3, т.к. они должны реплицироваться, но реплицироваться некуда, т.к. в кластере только один экземпляр elastic.
Сам кластер находится в состоянии yellow по причине того, что есть индексы в состоянии yellow.
```

Удалите все индексы.
```
[elastic@ee45316f568f /]$ curl -XDELETE localhost:9200/_all
{"acknowledged":true}
```

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

```
elastic@ee45316f568f /]$ mkdir /elasticsearch-7.9.3/snapshots
[elastic@ee45316f568f /]$ ls
anaconda-post.log  dev                  etc   lib    media  opt   root  sbin  sys  usr
bin                elasticsearch-7.9.3  home  lib64  mnt    proc  run   srv   tmp  var


[elastic@ee45316f568f /]$ curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
> {
>   "type": "fs",
>   "settings": {
>     "location": "/elasticsearch-7.9.3/snapshots"
>   }
> }
> '
Что-то пошло не так.
{
  "error" : {
    "root_cause" : [
      {
        "type" : "repository_exception",
        "reason" : "[netology_backup] location [/elasticsearch-7.9.3/snapshots] doesn't match any of the locations specified by path.repo because this setting is empty"
      }
    ],
    "type" : "repository_exception",
    "reason" : "[netology_backup] failed to create repository",
    "caused_by" : {
      "type" : "repository_exception",
      "reason" : "[netology_backup] location [/elasticsearch-7.9.3/snapshots] doesn't match any of the locations specified by path.repo because this setting is empty"
    }
  },
  "status" : 500
}


Добавим свежесозданный каталог в директиву path.repo конфига Эластика.

docker exec -it -u root:root netology-elastic bash
[root@47fb9edd1ef1 /]# yum install nano
[root@47fb9edd1ef1 /]# nano /elasticsearch-7.9.3/config/elasticsearch.yml

Добавим строку:
path.repo: ["/elasticsearch-7.9.3/snapshots"]

Перезапустим контейнер:
docker restart elastic

Регистрируем директорию:
[root@ee45316f568f /]# curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
  {
    "type": "fs",
    "settings": {
     "location": "/elasticsearch-7.9.3/snapshots"
    }
  }
  '
{
  "acknowledged" : true
}
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
```
[root@ee45316f568f /]# curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
>  {
>    "settings": {
>      "index": {
>        "number_of_shards": 1,
>        "number_of_replicas": 0
>      }
>    }
>  }
>  '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}

[root@ee45316f568f /]# curl 'localhost:9200/_cat/indices?v'
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  oFnPWvd2Q3maZvKvbGxQDQ   1   0          0            0       208b           208b

```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

```
[root@ee45316f568f /]# curl -X PUT "localhost:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "snapshot_1",
    "uuid" : "a2NNau3VQSOlGxngNuqbqg",
    "version_id" : 7090399,
    "version" : "7.9.3",
    "indices" : [
      "test"
    ],
    "data_streams" : [ ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2021-09-20T19:04:13.156Z",
    "start_time_in_millis" : 1632164653156,
    "end_time" : "2021-09-20T19:04:13.357Z",
    "end_time_in_millis" : 1632164653357,
    "duration_in_millis" : 201,
    "failures" : [ ],
    "shards" : {
      "total" : 1,
      "failed" : 0,
      "successful" : 1
    }
  }
}



[root@ee45316f568f snapshots]# ls -al
total 60
drwxrwxr-x 3 elastic elastic  4096 Sep 20 19:04 .
drwxr-xr-x 1 elastic root     4096 Sep 20 18:48 ..
-rw-r--r-- 1 elastic elastic   433 Sep 20 19:04 index-0
-rw-r--r-- 1 elastic elastic     8 Sep 20 19:04 index.latest
drwxr-xr-x 3 elastic elastic  4096 Sep 20 19:04 indices
-rw-r--r-- 1 elastic elastic 29389 Sep 20 19:04 meta-a2NNau3VQSOlGxngNuqbqg.dat
-rw-r--r-- 1 elastic elastic   266 Sep 20 19:04 snap-a2NNau3VQSOlGxngNuqbqg.dat

```


Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
```
[root@ee45316f568f snapshots]# curl -X DELETE "localhost:9200/test?pretty"
{
  "acknowledged" : true
}

[root@ee45316f568f snapshots]# curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 1,  
>       "number_of_replicas": 0 
>     }
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}

[root@ee45316f568f snapshots]# curl 'localhost:9200/_cat/indices?v'
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 k3JCVuUEQCGcoDju4OCRwg   1   0          0            0       208b           208b

```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
```
Восстановимся из снапшота:
[root@ee45316f568f snapshots]# curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty"

Смотрим список индексов:
[root@ee45316f568f snapshots]# curl 'localhost:9200/_cat/indices?v'
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 k3JCVuUEQCGcoDju4OCRwg   1   0          0            0       208b           208b
green  open   test   TZoZIe1zRoaPzRZ5VRzsNw   1   0          0            0       208b           208b

```
