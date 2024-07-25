# 19.1 Облачная инфраструктура. Terraform.  Никулин Александр
# Домашнее задание к занятию «Введение в Terraform»

### Цели задания

1. Установить и настроить Terrafrom.
2. Научиться использовать готовый код.

------
### Чек-лист готовности к домашнему заданию
<details>
  <summary>Раскрыть</summary>
  
  1. Скачайте и установите **Terraform** версии ~>1.8.4 . Приложите скриншот вывода команды ```terraform --version```.
     > ![image](https://github.com/user-attachments/assets/a6f45d9d-4deb-4ea4-8b4c-e589af93c67e)
  2. Скачайте на свой ПК этот git-репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.
     > ![image](https://github.com/user-attachments/assets/06695b92-1f92-4263-af3e-bf29cfff3c0f)
  3. Убедитесь, что в вашей ОС установлен docker.
     > ![image](https://github.com/user-attachments/assets/16cf7a14-305b-4b7a-9b45-278797bb8500)

</details>

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

<details>
  <summary>Раскрыть</summary>
  
  1. Репозиторий с ссылкой на зеркало для установки и настройки Terraform: [ссылка](https://github.com/netology-code/devops-materials).
  2. Установка docker: [ссылка](https://docs.docker.com/engine/install/ubuntu/). 
  ------
  ### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
  ------

</details>

### Задание 1

<details>
  <summary>Раскрыть</summary>
  
  1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте.
     > ![image](https://github.com/user-attachments/assets/08910fa7-5d90-4ba3-a91d-b128d0f2e2e0)
  3. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд)
     > можно хранить в файле personal.auto.tfvars
  5. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.
     > ![image](https://github.com/user-attachments/assets/a1578117-6cd1-475e-b01b-f2a92da85145) \
     > `"result": "LbtAhSAnuoj5LojV"`
  7. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**.
  Выполните команду ```terraform validate```. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.
      > ![image](https://github.com/user-attachments/assets/6327f52e-1604-474d-96c8-66c37262250c) \
      > ![image](https://github.com/user-attachments/assets/35a251c1-9a12-47e2-ab5c-f2858f53a0c8)\
      > ![image](https://github.com/user-attachments/assets/4f63b62e-de8c-462c-97b8-445ec0173f99)
      > ![image](https://github.com/user-attachments/assets/04bcd374-e712-4fc7-b263-a1532911c438)
      > 1. resource должен принимать на вход 2 аргумента, прнимал 1, задал имя
      > 2. некорректное имя контейнера (Должно начинаться на символы или нижнее подчеркивание)
      > 3. некорректное вызов аргумента в "random_password"
  9. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды ```docker ps```.
      > ```hcl
      >  terraform {
      >      required_providers {
      >        docker = {
      >          source  = "kreuzwerker/docker"
      >          version = "~> 3.0.1"
      >        }
      >      }
      >      required_version = "~>1.8.4" /*Многострочный комментарий.
      >     Требуемая версия terraform */
      >    }
      >    provider "docker" {}
      >    
      >    #однострочный комментарий
      >    
      >    resource "random_password" "random_string" {
      >      length      = 16
      >      special     = false
      >      min_upper   = 1
      >      min_lower   = 1
      >      min_numeric = 1
      >    }
      >    
      >    
      >    resource "docker_image" "nginx" {
      >      name         = "nginx:latest"
      >      keep_locally = true
      >    }
      >    
      >    resource "docker_container" "nginx1" {
      >      image = docker_image.nginx.image_id
      >      name  = "example_${random_password.random_string.result}"
      >    
      >      ports {
      >        internal = 80
      >        external = 9090
      >      }
      >    }
      > ```
      > ![image](https://github.com/user-attachments/assets/9ea91970-bc9c-42df-9c0a-c907554d8ca3)

  11. Замените имя docker-контейнера в блоке кода на ```hello_world```. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду ```terraform apply -auto-approve```.
  Объясните своими словами, в чём может быть опасность применения ключа  ```-auto-approve```. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды ```docker ps```.
      > ![image](https://github.com/user-attachments/assets/97e9d560-21db-4fc9-b65b-2306214b9482)
      > ![image](https://github.com/user-attachments/assets/ee90fb5e-7eff-48f9-af00-b1f96839d8f9)
      > минус ```-auto-approve```, что он не позволит проверить план выполнения какой-либоЮ где будет удален объект или ещё что-то в духе.
      > из плюсов, удобен в автоматизации ci/cd, там где уже (условно) все настроено и работает машина, где исключен человеческий фактор.
  13. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**.
      > ![image](https://github.com/user-attachments/assets/cb7522ef-f4cc-4a1a-801a-8204a3351732)
      > ```json
      > {
      >   "version": 4,
      >   "terraform_version": "1.8.5",
      >   "serial": 14,
      >   "lineage": "10c97181-79d3-63d3-2344-ab556ab22b8b",
      >   "outputs": {},
      >   "resources": [],
      >   "check_results": null
      > }
      > ```
  15. Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ **ОБЯЗАТЕЛЬНО НАЙДИТЕ В ПРЕДОСТАВЛЕННОМ КОДЕ**, а затем **ОБЯЗАТЕЛЬНО ПОДКРЕПИТЕ** строчкой из документации [**terraform провайдера docker**](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs).  (ищите в классификаторе resource docker_image )
      > https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs/resources/image#keep_locally
      > ```
      > keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.
      > ```
      > ![image](https://github.com/user-attachments/assets/302fd579-4646-4623-9c81-00a8de4d6cd4)

</details>
------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 2*

1. Создайте в облаке ВМ. Сделайте это через web-консоль, чтобы не слить по незнанию токен от облака в github(это тема следующей лекции). Если хотите - попробуйте сделать это через terraform, прочитав документацию yandex cloud. Используйте файл ```personal.auto.tfvars``` и гитигнор или иной, безопасный способ передачи токена!
2. Подключитесь к ВМ по ssh и установите стек docker.
3. Найдите в документации docker provider способ настроить подключение terraform на вашей рабочей станции к remote docker context вашей ВМ через ssh.
4. Используя terraform и  remote docker context, скачайте и запустите на вашей ВМ контейнер ```mysql:8``` на порту ```127.0.0.1:3306```, передайте ENV-переменные. Сгенерируйте разные пароли через random_password и передайте их в контейнер, используя интерполяцию из примера с nginx.(```name  = "example_${random_password.random_string.result}"```  , двойные кавычки и фигурные скобки обязательны!) 
```
    environment:
      - "MYSQL_ROOT_PASSWORD=${...}"
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - "MYSQL_PASSWORD=${...}"
      - MYSQL_ROOT_HOST="%"
```

6. Зайдите на вашу ВМ , подключитесь к контейнеру и проверьте наличие секретных env-переменных с помощью команды ```env```. Запишите ваш финальный код в репозиторий.

### Задание 3*
1. Установите [opentofu](https://opentofu.org/)(fork terraform с лицензией Mozilla Public License, version 2.0) любой версии
2. Попробуйте выполнить тот же код с помощью ```tofu apply```, а не terraform apply.
------

### Правила приёма работы

Домашняя работа оформляется в отдельном GitHub-репозитории в файле README.md.   
Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 
