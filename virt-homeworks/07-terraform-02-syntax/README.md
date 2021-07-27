____
### Задача 1. Регистрация в aws и знакомство с основами (необязательно, но крайне желательно).
____
#### В виде результата задания приложите вывод команды aws configure list.
```bash
Aleksandr@DESKTOP-FLQBJ70 MINGW64 ~/.aws
$ aws configure list
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None
access_key     ****************QZUZ              env
secret_key     ****************zKXH              env
    region                us-east-2      config-file    ~/.aws/config



```
____
### Задача 2. Созданием ec2 через терраформ
___
##### Если вы выполнили первый пункт, то добейтесь того, что бы команда terraform plan выполнялась без ошибок.
```bash
Aleksandr@DESKTOP-FLQBJ70 MINGW64 /f/netology_hw/devops-netology/virt-homeworks/07-terraform-02-syntax ((6dc3050...))
$ terraform plan

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
...
Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + account_id = "088855944609"
  + private_ip = [
      + (known after apply),
    ]
  + region     = "us-west-2"
  + subnet_id  = [
      + (known after apply),
    ]
  + user_id    = "AIDARJMB2DWQRTGFEUJ3B"

─────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
...

```
#### Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
`Packer от HashiCorp `
#### Ссылку на репозиторий с исходной конфигурацией терраформа.
[Ссылка на репозиторий Terraform](https://github.com/AleksandrZolnikov/devops-netology/tree/main/virt-homeworks/07-terraform-02-syntax)
