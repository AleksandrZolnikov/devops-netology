### Задача 1 
### Написанный вами Dockerfile
#### 1-ый вариант решения
```bash
FROM archlinux:latest	
RUN pacman -Suy --noconfirm
RUN pacman -Syu ponysay --noconfirm
ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology”] 
```
#### 2-ой вариант решения
```bash
FROM archlinux:latest
RUN useradd -m notroot
RUN pacman -Sy python3 --noconfirm
RUN pacman -Syu --noconfirm
RUN pacman -Sy --noconfirm git
RUN pacman -S binutils make gcc pkg-config fakeroot --noconfirm
RUN echo "notroot ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers
USER notroot
WORKDIR /home/notroot
RUN git clone https://github.com/erkin/ponysay.git
USER root
RUN cd ponysay && python3 setup.py --freedom=strict install
ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology”]
```
### Ссылку на образ в вашем хранилище docker-hub
[Ссылка на образ в docker-hub ver_1](https://hub.docker.com/layers/146918945/aleksandrzol/netology/ponasay_v1/images/sha256-b79f151db3d5d79ede3aec0688dd8a2338c52f4b0301ba5b405a74c12e33c5bd?context=repo)\
[Ссылка на образ в docker-hub ver_2](https://hub.docker.com/layers/147010380/aleksandrzol/netology/ponasay_v2/images/sha256-ce22ca5e85c811bc87b8806d1f3548bdd513643bc3b138798ae33ca4a4adf3f6?context=repo)
### Скриншот вывода командной строки после запуска контейнера из вашего базового образа
![photo_2021-04-25_20-32-17](https://user-images.githubusercontent.com/76260506/125505894-7b671c6a-bd40-4c75-9695-f09f640c6d22.jpg "Скриншот вывода" )

### Задача 2
#### Наполнения 2х Dockerfile из задания
##### amazoncorreto
```bash
Jenkins: amazoncorretto
FROM amazoncorretto
USER root
RUN yum -y update
RUN yum install java-1.8.0 -y
RUN yum update -y
RUN yum install wget -y
RUN yum install -y initscripts
RUN wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
RUN rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key  
RUN yum install jenkins -y
ENTRYPOINT /etc/init.d/jenkins start && /bin/bash
EXPOSE 8080
```
##### ubuntu:latest
```bash
FROM ubuntu:latest
USER root
RUN apt-get update && apt-get install -y gnupg2
RUN apt-get update && apt-get install openjdk-8-jdk openjdk-8-jre -y
RUN apt install wget -y
RUN wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
RUN sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN apt update -y
RUN apt install jenkins -y
RUN service jenkins start
ENTRYPOINT /etc/init.d/jenkins start && /bin/bash
EXPOSE 8080
```
