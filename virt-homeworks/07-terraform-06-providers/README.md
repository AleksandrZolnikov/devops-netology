# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  
___
#### 1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.
#### Ответ:
`data_source:`
[https://github.com/hashicorp/terraform-provider-aws](https://github.com/hashicorp/terraform-provider-aws/blob/1776cbf7cac4a821fcc3aebe06fc52845aab4e11/aws/provider.go#L167)

`resource:`
[https://github.com/hashicorp/terraform-provider-aws](https://github.com/hashicorp/terraform-provider-aws/blob/1776cbf7cac4a821fcc3aebe06fc52845aab4e11/aws/provider.go#L394)
___
#### 2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name` 
___
     С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
    
   [https://github.com/hashicorp/terraform-provider-aws](https://github.com/hashicorp/terraform-provider-aws/blob/1776cbf7cac4a821fcc3aebe06fc52845aab4e11/aws/resource_aws_sqs_queue.go#L56)
___
     Какая максимальная длина имени? 

   [https://github.com/hashicorp/terraform-provider-aws](https://github.com/hashicorp/terraform-provider-aws/blob/1776cbf7cac4a821fcc3aebe06fc52845aab4e11/aws/validators.go#L1031)
___
     Какому регулярному выражению должно подчиняться имя? 
        
   [https://github.com/hashicorp/terraform-provider-aws](https://github.com/hashicorp/terraform-provider-aws/blob/1776cbf7cac4a821fcc3aebe06fc52845aab4e11/aws/validators.go#L1035)
___
