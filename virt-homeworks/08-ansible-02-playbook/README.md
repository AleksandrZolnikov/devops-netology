#### 1. Приготовьте свой собственный inventory файл prod.yml.

#### 2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.

#### 3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.

#### 4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.

#### 5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

#### 6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

#### 7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

#### 8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

### 9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.  
 

```yml
---
- name: Install Java # Установка джавы
  hosts: all # Выполнение на всех хостах
  tasks:
    - name: Set home dir for Java 11 
      set_fact:
        java_home: "/opt/jdk/{{ java_jdk_version }}" # Путь  к установочной директории java
      tags: java # все таски  помечены тегом java
    - name: Upload .tar.gz file containing binaries from local storage
      copy: # копирование файлов на удаленные хосты
        src: "{{ java_oracle_jdk_package }}" # локальный путь к файлу
        dest: "/tmp/jdk-{{ java_jdk_version }}.tar.gz" # Путь куда будет копироваться этот файл на удаленном сервере
        mode: 0644 # Задаем права на файл
      register: download_java_binaries # Запись результата выполнение таски
      until: download_java_binaries is succeeded # повторять таск пока команда не выполнется успешно 
      tags: java # все таски  помечены тегом java
    - name: Ensure installation dir exists # 
      become: true # делаем от рута
      file:
        state: directory # если директория отсутствует - создать
        path: "{{ java_home }}" # путь к установочной директории
        mode: 0644 Задаем права на файл
      tags: java
    - name: Extract java in the installation directory
      become: true
      unarchive: # разархивируем
        copy: false # если false, плагин ищет архив на управляемом хосте
        src: "/tmp/jdk-{{ java_jdk_version }}.tar.gz" # локальный путь к архиву
        dest: "{{ java_home }}" # Путь куда будет разархивироваться архив
        extra_opts: [--strip-components=1] # удаляет верхнюю директорию при распаковке
        creates: "{{ java_home }}/bin/java" # если  путь на удаленном сервере уже существует, таск не будет выполняться
        mode: 0644
      tags:
        - java
    - name: Export environment variables
      become: true
      template: # копирование файла конфигурации
        src: jdk.sh.j2 # откуда будет копироваться конфигаруционный шаблон с локального хоста 
        dest: /etc/profile.d/jdk.sh # куда будет копироваться конфигаруционный шаблон на удаленный хост
        mode: 0644 
      tags: java

- name: Install Elasticsearch # play для установки elc
  hosts: elasticsearch # группа "elasticsearch"
  tasks:
    - name: Upload tar.gz Elasticsearch from remote URL
      get_url:
        url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz" # качаем с просторов интернета архивчик
        dest: "/tmp/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz" # куда будет скопирован архив на удаленном хосте
        mode: 0755 # права
        timeout: 60  # таймаут запроса
        force: true # перезаписать файл, если существует
        validate_certs: false # проверить SSL сертификат
      register: get_elastic 
      until: get_elastic is succeeded
      tags: elastic
    - name: Create directrory for Elasticsearc
      become: true
      file:
        state: directory
        path: "{{ elastic_home }}"
        mode: 0644
      tags: elastic
    - name: Extract Elasticsearch in the installation directory
      become: true
      unarchive:
        copy: false
        src: "/tmp/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz"
        dest: "{{ elastic_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ elastic_home }}/bin/elasticsearch"
        mode: 0644
      tags:
        - elastic
    - name: Set environment Elastic
      become: true
      template: 
        src: templates/elk.sh.j2
        dest: /etc/profile.d/elk.sh
        mode: 0644
      tags: elastic

- name: Install Kibana
  hosts: kibana # будет установлен на хостах группы "kibana"
  tasks:
    - name: Upload tar.gz Kibana from remote URL
      get_url:
        url: "https://artifacts.elastic.co/downloads/kibana/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        mode: 0755
        timeout: 60
        force: true
        validate_certs: false
      register: get_kibana
      until: get_kibana is succeeded
      tags: kibana
    - name: Create directrory for Kibana
      become: true
      file:
        state: directory
        path: "{{ kibana_home }}"
        mode: 0644
      tags: kibana
    - name: Extract Kibana in the installation directory
      become: true
      unarchive:
        copy: false
        src: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "{{ kibana_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ kibana_home }}/bin/kibana"
        mode: 0644
      tags:
        - kibana
    - name: Set environment kibana
      become: true
      template:
        src: templates/kibana.sh.j2
        dest: /etc/profile.d/kibana.sh
        mode: 0644
      tags: kibana
      
```
