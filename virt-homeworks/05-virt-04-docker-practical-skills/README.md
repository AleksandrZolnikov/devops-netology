### Задача 1 
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
[Ссылка на образ в docker-hub ver_1](https://hub.docker.com/layers/146918945/aleksandrzol/netology/ponasay_v1/images/sha256-b79f151db3d5d79ede3aec0688dd8a2338c52f4b0301ba5b405a74c12e33c5bd?context=repo)\
[Ссылка на образ в docker-hub ver_2](https://hub.docker.com/layers/147010380/aleksandrzol/netology/ponasay_v2/images/sha256-ce22ca5e85c811bc87b8806d1f3548bdd513643bc3b138798ae33ca4a4adf3f6?context=repo)
### Задача 2
