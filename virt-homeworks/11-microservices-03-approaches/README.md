## Домашнее задание к занятию "11.03 Микросервисы: подходы"

Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.


### Задача 1: Обеспечить разработку

Предложите решение для обеспечения процесса разработки: хранение исходного кода, непрерывная интеграция и непрерывная поставка. 
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- Облачная система;
- Система контроля версий Git;
- Репозиторий на каждый сервис;
- Запуск сборки по событию из системы контроля версий;
- Запуск сборки по кнопке с указанием параметров;
- Возможность привязать настройки к каждой сборке;
- Возможность создания шаблонов для различных конфигураций сборок;
- Возможность безопасного хранения секретных данных: пароли, ключи доступа;
- Несколько конфигураций для сборки из одного репозитория;
- Кастомные шаги при сборке;
- Собственные докер образы для сборки проектов;
- Возможность развернуть агентов сборки на собственных серверах;
- Возможность параллельного запуска нескольких сборок;
- Возможность параллельного запуска тестов;

Обоснуйте свой выбор.  

*Ответ:*  
Jenkins в связке с Github:  
а) Запуск джобы по событиям GithubA.
б) Разворачиваение Jenkins в облаке. (присутствуют готовые решения у DigitalOcean, MS Azure).  
в) Запуск джобы в ручную с указанием параметров ( переменных ).  
г) Выкатка агентов как в облаке так и на своих серверах.  
д) Присутствуют оффициальные docker-образы: https://hub.docker.com/u/jenkins.  
е) Возможность параллельного запуска нескольких сборок ( количество зависит от платной/бесплатной версии Jenkins )  
ж) Параллельный запуск тестов.  
з) Безопасное хранение секретов ( токены, ключи ).  

---

### Задача 2: Логи

Предложите решение для обеспечения сбора и анализа логов сервисов в микросервисной архитектуре.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- Сбор логов в центральное хранилище со всех хостов обслуживающих систему;
- Минимальные требования к приложениям, сбор логов из stdout;
- Гарантированная доставка логов до центрального хранилища;
- Обеспечение поиска и фильтрации по записям логов;
- Обеспечение пользовательского интерфейса с возможностью предоставления доступа разработчикам для поиска по записям логов;
- Возможность дать ссылку на сохраненный поиск по записям логов;

Обоснуйте свой выбор.  

*Ответ:*  
ELK:  
а) ElasticSearch - полнотекстовый поисковый и аналитический движок и документоориентированная БД.  
б) Logstash - сбор логов.  
в) Kibana - визуализатор логов, содержащихся в базе ES.  
 

---

### Задача 3: Мониторинг

Предложите решение для обеспечения сбора и анализа состояния хостов и сервисов в микросервисной архитектуре.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- Сбор метрик со всех хостов, обслуживающих систему;
- Сбор метрик состояния ресурсов хостов: CPU, RAM, HDD, Network;
- Сбор метрик потребляемых ресурсов для каждого сервиса: CPU, RAM, HDD, Network;
- Сбор метрик, специфичных для каждого сервиса;
- Пользовательский интерфейс с возможностью делать запросы и агрегировать информацию;
- Пользовательский интерфейс с возможность настраивать различные панели для отслеживания состояния системы;

Обоснуйте свой выбор.  

*Ответ:*  
Prometheus + Node exporters + Grafana:  
Prometheus - БД временных рядов с возможностью опроса внешних источников + HTTP сервер извлекает метрики через HTTP запросы.  \
Node exporters - снятие метрик и передача их в нормальный вид для Prometheus \
Grafana - визуализация метрик, вывод метрик в "графическом варианте" \
Актуальная и информативная оффициальная документация. Готовые решения дашбордов. Присутствие оффициальных docker-образов.

