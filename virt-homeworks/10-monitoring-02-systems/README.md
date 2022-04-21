# Домашнее задание к занятию "10.02. Системы мониторинга"

## Обязательные задания

1. Опишите основные плюсы и минусы pull и push систем мониторинга.

### Push

#### Плюсы

- Упрощение репликации данных в разные системы мониторинга или их резервные копи.
- Более гибкая настройка отправки пакетов данных с  метрик.
- UDP является менее затратным способом передачи данных, вследствии чего может вырости производительность сбора метр.

#### Минусы

- Неободимость агентов.
- Необходимость организации очередей входящих данных на центральном узле при большом количестве агентов.

### Pull

#### Плюсы

- Можно настроить единый proxy-server до всех агентов с TLS.
- Упрощенная отладка получения данных с агентов .
- Легче контролировать подлинность данных 

#### Минусы

- Высокая нагрузка на центральный узел.
- Единая точка отказа в виде центрального сервера.
- Необходимость знать актуальные адреса всех хостов, которых может быть очень много.

---

2. Какие из ниже перечисленных систем относятся к push модели, а какие к pull? А может есть гибридные?

- Prometheus - по-умолчанию pull, но с помощью дополнительного сервиса Pushgateway может работать как push.
- TICK -  push. 
- Zabbix - pull/push (гибридная).
- VictoriaMetrics - pull/push. высокоскоростная БД для хранения метрик.
- Nagios - pull/push. Два режима работы - Active Check и Passive Check. 

---

3. Склонируйте себе [репозиторий](https://github.com/influxdata/sandbox/tree/master) и запустите TICK-стэк, 
используя технологии docker и docker-compose.

В виде решения на это упражнение приведите выводы команд с вашего компьютера (виртуальной машины):

```sh
    - curl http://localhost:8086/ping
    - curl http://localhost:8888
    - curl http://localhost:9092/kapacitor/v1/ping
```
А также скриншот веб-интерфейса ПО chronograf (`http://localhost:8888`). 

P.S.: если при запуске некоторые контейнеры будут падать с ошибкой - проставьте им режим `Z`, например
`./data:/var/lib:Z`

---

### 3. Решение

```bash
$ curl http://localhost:8086/ping -v
*   Trying 127.0.0.1:8086...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8086 (#0)
> GET /ping HTTP/1.1
> Host: localhost:8086
> User-Agent: curl/7.68.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 204 No Content
< Content-Type: application/json
< Request-Id: cb99950d-7885-11ec-81ea-0242ac120002
< X-Influxdb-Build: OSS
< X-Influxdb-Version: 1.8.10
< X-Request-Id: cb99950d-7885-11ec-81ea-0242ac120002
< Date: Thu, 21 Apr 2022 11:37:34 GMT
< 
* Connection #0 to host localhost left intact
```
```bash
$ curl http://localhost:8888
<!DOCTYPE html><html><head><meta http-equiv="Content-type" content="text/html; charset=utf-8"><title>Chronograf</title><link rel="icon shortcut" href="/favicon.fa749080.ico"><link rel="stylesheet" href="/src.3dbae016.css"></head><body> <div id="react-root" data-basepath=""></div> <script src="/src.fab22342.js"></script> </body></html>
```
```bash
$ curl http://localhost:9092/kapacitor/v1/ping -v
*   Trying 127.0.0.1:9092...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9092 (#0)
> GET /kapacitor/v1/ping HTTP/1.1
> Host: localhost:9092
> User-Agent: curl/7.68.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 204 No Content
< Content-Type: application/json; charset=utf-8
< Request-Id: e379ddbc-7885-11ec-81c6-000000000000
< X-Kapacitor-Version: 1.6.2
< Date: Thu, 21 Apr 2022 11:39:03 GMT
< 
* Connection #0 to host localhost left intact
```
![1](https://github.com/AleksandrZolnikov/devops-netology/blob/main/virt-homeworks/10-monitoring-02-systems/1.png)

---

4. Перейдите в веб-интерфейс Chronograf (`http://localhost:8888`) и откройте вкладку `Data explorer`.

    - Нажмите на кнопку `Add a query`
    - Изучите вывод интерфейса и выберите БД `telegraf.autogen`
    - В `measurments` выберите mem->host->telegraf_container_id , а в `fields` выберите used_percent. 
    Внизу появится график утилизации оперативной памяти в контейнере telegraf.
    - Вверху вы можете увидеть запрос, аналогичный SQL-синтаксису. 
    Поэкспериментируйте с запросом, попробуйте изменить группировку и интервал наблюдений.

Для выполнения задания приведите скриншот с отображением метрик утилизации места на диске 
(disk->host->telegraf_container_id) из веб-интерфейса.

---

### 4. Решение

![1](https://github.com/AleksandrZolnikov/devops-netology/blob/main/virt-homeworks/10-monitoring-02-systems/2.png)

---

5. Изучите список [telegraf inputs](https://github.com/influxdata/telegraf/tree/master/plugins/inputs). 
Добавьте в конфигурацию telegraf следующий плагин - [docker](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/docker):
```
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
```

Дополнительно вам может потребоваться донастройка контейнера telegraf в `docker-compose.yml` дополнительного volume и 
режима privileged:

```yml
  telegraf:
    image: telegraf:1.4.0
    privileged: true
    volumes:
      - ./etc/telegraf.conf:/etc/telegraf/telegraf.conf:Z
      - /var/run/docker.sock:/var/run/docker.sock:Z
    links:
      - influxdb
    ports:
      - "8092:8092/udp"
      - "8094:8094"
      - "8125:8125/udp"
```

После настройке перезапустите telegraf, обновите веб интерфейс и приведите скриншотом список `measurments` в 
веб-интерфейсе базы telegraf.autogen . Там должны появиться метрики, связанные с docker.

Факультативно можете изучить какие метрики собирает telegraf после выполнения данного задания.

---

### 5. Решение

После перезапуска новые метрики не появились. Для работы потребовались дополнительные права на /var/run/docker.sock:

```bash
sudo chmod 666 /var/run/docker.sock
```
![1](https://github.com/AleksandrZolnikov/devops-netology/blob/main/virt-homeworks/10-monitoring-02-systems/3.png)
---

