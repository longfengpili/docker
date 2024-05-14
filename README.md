"# docker" 


+ 容器中访问docker
```docker
    volumes:
      - type: bind
        source: /var/run/docker.sock
        # source: //var/run/docker.sock  # windows
        target: /var/run/docker.sock
      - type: bind  # if not work, can delete this bind
        source: /usr/bin/docker
        target: /usr/bin/docker
```
+ 增加root
```docker
user: root
```
+ Dockerfile中不能update
```
RUN echo "deb http://mirrors.aliyun.com/debian/ bookworm main contrib non-free" > /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian/ bookworm-updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian/ bookworm-backports main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian-security/ bookworm-security main contrib non-free" >> /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        python3
```
+ docker-compose增加hosts
```
    extra_hosts:
      - "host.docker.internal:host-gateway"
      - "github.com:20.205.243.166"
```
```
services:
  nginx:
    image: nginx:latest
    container_name: superset_nginx
    restart: unless-stopped
    ports:
      - "80:80"
    extra_hosts:
      - "host.docker.internal:host-gateway"
      - "github.com:20.205.243.166"  
    volumes:
      - ./docker/nginx/nginx.conf:/etc/nginx/nginx.conf:ro
```