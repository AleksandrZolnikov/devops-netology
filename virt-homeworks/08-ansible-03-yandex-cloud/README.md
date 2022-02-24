# 08.03 Использование Yandex Cloud

#### 1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.
```yaml
- name: Install Kibana
  hosts: kibana
  handlers: 			# Дополняем задачу хенджералми ( обработчика)
    - name: restart Kibana      # Название хендлера
      become: true              # Выполняем от рута
      systemd:			# Запускаем службу systemd
        name: kibana		# Соответственно какую будем службу рестортавать ( кибана )
        state: restarted	# Рестартуем Kibane ПОСЛЕ ВЫПОЛНЕНИЯ ТАСКА
      tags: kibana		# Все таски  помечены тегом kibana
  tasks:
    - name: "Download Kibana's"   # Название таски
      get_url: 
        url: "https://artifacts.elastic.co/downloads/kibana/kibana-{{ elk_stack_version }}--x86_64.rpm" # Скачиваем артефакты
        dest: "/tmp/kibana-{{ elk_stack_version }}--x86_64.rpm" # Указываем в какую папку копируем на удаленном сервере
        mode: 0755			 # Задаем права на файл
      register: download_kibana		 # Записываем результат выполнение таски
      until: download_kibana is succeeded   # Повторять таск пока команда не выполнется успешно
      tags: kibana		# Все таски  помечены тегом kibana

    - name: Install Kibana      # Название таски
      become: true 		# Выполняем от рута
      yum:
        name: "/tmp/kibana-{{ elk_stack_version }}-x86_64.rpm"  # Откуда устанавливаем
        state: present 		# Установить если есть другой дистриб
      tags: kibana		# Все таски  помечены тегом kibana

    - name: Configure Kibana    # Название таски
      become: true		# Выполняем от рута
      template:			# Заменяем конфигурационный файл
        src: kibana.yml.j2	# Копируем с локальной машины
        dest: /etc/kibana/kibana.yml # Копируем на удаленный сервер
        mode: 0644		# Задаем права на файл
      notify: Restart Kibana    # Выполнить хенлдлер с названием Restart Kibana
      tags: kibana		# Все таски  помечены тегом kibana
```
#### 2. При создании tasks рекомендую использовать модули: get_url, template, yum, apt.
Выполнено

#### 3. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.
Выполнено

#### 4.Приготовьте свой собственный inventory файл prod.yml.

```yaml
$ cat inventory/prod/hosts.yml
---

elasticsearch:
  hosts:
    el-instance:
      ansible_host: 34.231.171.181
      ansible_connection: ssh
      ansible_user: centos
kibana:
  hosts:
    k-instance:
      ansible_host: 34.268.113.192
      ansible_connection: ssh
      ansible_user: centos
```   
#### 5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```yaml
$ ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
```

#### 6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```yaml
$ ansible-playbook -i inventory/prod/hosts.yml site.yml --check

PLAY [Install Elasticsearch] ********************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************
ok: [el-instance]

TASK [Download Elasticsearch's rpm] *************************************************************************************************
changed: [el-instance]

TASK [Install Elasticsearch] ********************************************************************************************************
fatal: [el-instance]: FAILED! => {"changed": false, "msg": "No RPM file matching '/tmp/elasticsearch-7.15.2-x86_64.rpm' found on system", "rc": 127, "results": ["No RPM file matching '/tmp/elasticsearch-7.15.2-x86_64.rpm' found on system"]}

PLAY RECAP **************************************************************************************************************************
el-instance                : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```

#### 7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```yaml
$ ansible-playbook site.yml -i inventory/prod/hosts.yml --diff

---

TASK [Configure Kibana] ***********************************************************************************************************

changed: [k-instance]

RUNNING HANDLER [Restart Kibana] **************************************************************************************************
changed: [k-instance]

PLAY RECAP ************************************************************************************************************************
el-instance                : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
k-instance                 : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

#### 8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```yaml
$ ansible-playbook site.yml -i inventory/prod/hosts.yml --diff
---

PLAY RECAP ************************************************************************************************************************
el-instance                : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
k-instance                 : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

#### 9. Проделайте шаги с 1 до 8 для создания ещё одного play, который устанавливает и настраивает filebeat.

```yaml
$ cat inventory/prod/hosts.yml

elasticsearch:
  hosts:
    el-instance:
      ansible_host: 34.231.171.181
      ansible_connection: ssh
      ansible_user: centos
kibana:
  hosts:
    k-instance:
      ansible_host: 34.268.113.192
      ansible_connection: ssh
      ansible_user: centos
filebeat:
  hosts:
    f-instance:
      ansible_host: 34.304.129.1171
      ansible_connection: ssh
      ansible_user: centos
```

#### 10. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
Подготовил - описание плейбука смотрите в 1 ом пункте - далее все модули по описанию повторяются.

#### 11. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.
Приложил ссылку в ДЗ.

