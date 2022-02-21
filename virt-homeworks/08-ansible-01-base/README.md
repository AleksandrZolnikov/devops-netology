### Результаты выполнения плейбука приложил кусками для более лучшей читабельности.
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
```bash
aszolnikov@ubuntu:~/playbook# ansible-playbook site.yml --inventory ./inventory/test.yml
---
TASK [Print fact] **********************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}
```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
```bash
aszolnikov@ubuntu:~/playbook# ansible-playbook -i ./inventory/prod.yml site.yml
TASK [Print fact] **********************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}
```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
```bash
aszolnikov@ubuntu:~/playbook# ansible-playbook -i ./inventory/prod.yml site.yml

TASK [Print fact] **********************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
```
8. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
```bash
aszolnikov@ubuntu:~/playbook# ansible-vault encrypt ./group_vars/deb/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
aszolnikov@ubuntu:~/playbook# cat ./group_vars/deb/examp.yml
$ANSIBLE_VAULT;1.1;AES256
64646663353066373635313265343232313630386536656236323434396631306439646261316433
6330316638633364396333326632356633376235663861380a653765643061646232623064313036
37643637353035313730336362633330653338323936333436396361633864383263613662303430
3565363437316265640a613536613161386230653533396636666461626431303961663765616266
61316237633332343466396562613066396336316466333634386266653662636634373163636436
3339363861313366653464616265363539333266333331643636

aszolnikov@ubuntu:~/playbook# ansible-vault encrypt ./group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful

aszolnikov@ubuntu:~/playbook# cat ./group_vars/el/examp.yml
$ANSIBLE_VAULT;1.1;AES256
34383737663835616536666331613433373931623635653835623363303439323430643266303362
3234626335656261396539363633303434653731663932610a393238306332623833326466323131
38353339396330633562666662396161653666653262316438363432386231666562666431343338
3561313232643630380a653734303337363034353665316364363364373738353934356162313738
64323462663233396530623365303033393238313635633439366365373536363831363963613237
6635383834656538646361633665353139643937313232663134
```
Расшифровка
```bash
aszolnikov@ubuntu:~/playbook# ansible-vault decrypt ./group_vars/deb/examp.yml
Vault password:
Decryption successful

aszolnikov@ubuntu:~/playbook# ansible-vault decrypt ./group_vars/el/examp.yml
Vault password:
Decryption successful

aszolnikov@ubuntu:~/playbook# cat ./group_vars/el/examp.yml
---
  some_fact: "el default fact"

aszolnikov@ubuntu:~/playbook# cat ./group_vars/deb/examp.yml
---
  some_fact: "deb default fact"
```
9. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
```bash
aszolnikov@ubuntu:~/playbook# ansible-playbook -i ./inventory/prod.yml site.yml --ask-vault-pass
Vault password:
[WARNING]: ansible.utils.display.initialize_locale has not been called, this may result in incorrectly calculated text widths that can cause Display to print incorrect line lengths

TASK [Print fact] **********************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *****************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
10. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
```bash
aszolnikov@ubuntu:~/playbook# ansible-doc -t connection -l
community.docker.docker     Run tasks in docker containers
community.docker.docker_api Run tasks in docker containers
community.docker.nsenter    execute on host running controller container
local                       execute on controller
paramiko_ssh                Run tasks via python ssh (paramiko)
psrp                        Run tasks over Microsoft PowerShell Remoting Protocol
ssh                         connect via ssh client binary
winrm                       Run tasks over Microsoft's WinRM
```
Подходит "local"

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
```bash
aszolnikov@ubuntu:~/playbook# ansible-playbook -i ./inventory/prod.yml site.yml --ask-vault-pass
Vault password:
[WARNING]: ansible.utils.display.initialize_locale has not been called, this may result in incorrectly calculated text widths that can cause Display to print incorrect line lengths


TASK [Print OS] ************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *****************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

# Самоконтроль выполненения задания

1. Где расположен файл с `some_fact` из второго пункта задания?
```bash
playbook/group_vars/all/examp.yml
```
2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?
```bash
ansible-playbook -i inventory/test.yml site.yml
```
3. Какой командой можно зашифровать файл?
```bash
ansible-vault encrypt examp.yml
```
4. Какой командой можно расшифровать файл?
```bash
ansible-vault decrypt examp.yml
```
5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?
```bash
ansible-vault view examp.yml
```
6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?

```bash
ansible-playbook -i inventory/prod.yml --ask-pass --ask-vault-pass site.yml
```
7. Как называется модуль подключения к host на windows?
```bash
winrm
```
8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh
```bash
ansible-doc -t connection ssh
```
9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?
```bash
remote_user
```
 
