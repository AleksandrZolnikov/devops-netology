# Домашнее задание к занятию "8.4 Работа с Roles"

## Подготовка к выполнению
1. #### Создайте два пустых публичных репозитория в любом своём проекте: kibana-role и filebeat-role.
2. #### Добавьте публичную часть своего ключа к своему профилю в github.

## Основная часть

#### Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для elastic, kibana, filebeat и написать playbook для использования этих ролей. Ожидаемый результат: существуют два ваших репозитория с roles и один репозиторий с playbook.

1. #### Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:
   ```yaml
   ---
     - src: git@github.com:netology-code/mnt-homeworks-ansible.git
       scm: git
       version: "2.1.4"
       name: elastic 
   ```
#### 2. При помощи `ansible-galaxy` скачать себе эту роль.  
   `ansible-galaxy install -r requirements.yml -p roles`
#### 3. Создать новый каталог с ролью при помощи `ansible-galaxy role init kibana-role`.
#### 4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
#### 5. Перенести нужные шаблоны конфигов в `templates`.
#### 6. Создать новый каталог с ролью при помощи `ansible-galaxy role init filebeat-role`.
#### 7. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
#### 8. Перенести нужные шаблоны конфигов в `templates`.
#### 9. Описать в `README.md` обе роли и их параметры.
#### 10. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию.
    Проставил теги - 2.1.4
#### 11. Добавьте roles в `requirements.yml` в playbook.
   ```yaml
---
  - src: git@github.com:netology-code/mnt-homeworks-ansible.git
    scm: git
    version: "2.1.4"
    name: elastic
  - src: git@github.com:AleksandrZolnikov/kibana-role.git
    scm: git
    version: "2.1.4"
    name: kibana_role
  - src: git@github.com:AleksandrZolnikov/filebeat-role.git
    scm: git
    version: "2.1.4"
    name: filebeat_role  
   ```
12. #### Переработайте playbook на использование roles.
   ```yaml
   - name: Install elasticsearch-role
     hosts: elasticsearch
     roles:
       - elastic
   - name: Install kibana-role
     hosts: kibana
     roles:
       - kibana-role
   - name: Install filebeat-role
     hosts: app
     roles:
       - filebeat-role
   ```
13. #### Выложите playbook в репозиторий.
   https://github.com/AleksandrZolnikov/devops-netology/tree/main/virt-homeworks/08-ansible-04-role \
14. #### В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook. \
   [kibana-role](https://github.com/AleksandrZolnikov/kibana-role)  
   [filebeat-role](https://github.com/AleksandrZolnikov/filebeat-role)  \
   [playbook](https://github.com/AleksandrZolnikov/devops-netology/tree/main/virt-homeworks/08-ansible-04-role) 
