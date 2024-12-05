"# docker" 


## 容器中访问docker
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
## 增加root
```docker
user: root
```
## Dockerfile中不能update
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
```
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list
```
## docker-compose增加hosts
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
## sh脚本中引入全局变量
```
#!/bin/bash
# @Author: longfengpili
# @Date:   2024-03-25 13:39:46
# @Last Modified by:   longfengpili
# @Last Modified time: 2024-06-07 13:33:30

set -a
source /workspace/trinoapi/.env
set +a
```

## Dockerfile中增加代理(以访问外网下载更新)
```dockerfile
ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTPS_PROXY}
```

## `.env` 文件、`environment` 和 `env_file`

### 不同方法的用途和特点

1. `.env` 文件

- **用途**：
  - `.env` 文件用于存储项目的全局配置变量。Docker Compose 在运行时会自动加载与 `docker-compose.yml` 文件位于同一目录下的 `.env` 文件。
  - 适用于简单的、全局的变量替换。

- **特点**：
  - 自动加载，省去在 `docker-compose.yml` 中显式引用的步骤。
  - 通常用于为 `docker-compose.yml` 中的变量提供默认值。

- **示例**：

  `.env` 文件：
  ```plaintext
  IMAGE_TAG=latest
  HOST_PORT=8080
  CONTAINER_PORT=80
  ```

  `docker-compose.yml` 文件：
  ```yaml
  version: '3.8'

  services:
    web:
      image: "myapp:${IMAGE_TAG}"
      ports:
        - "${HOST_PORT}:${CONTAINER_PORT}"
  ```

2. `environment`

- **用途**：
  - 在 `docker-compose.yml` 文件中为某个服务直接指定环境变量。

- **特点**：
  - 高优先级，适用于明确、关键的变量配置。
  - 支持直接在 `docker-compose.yml` 中书写，简单直接。

- **示例**：

  ```yaml
  version: '3.8'

  services:
    database:
      image: mysql
      environment:
        MYSQL_ROOT_PASSWORD: example
        MYSQL_DATABASE: mydb
        HOST_IP: ${HOST_IP}       # 使用 .env 中的变量
  ```

3. `env_file`

- **用途**：
  - 可以在 `docker-compose.yml` 中指定一个或多个文件，从中加载大量环境变量。

- **特点**：
  - 用于管理大量或复用的环境变量，保持 `docker-compose.yml` 文件简洁。
  - 需要显式在服务配置中引用这些文件。

- **示例**：

  `env.list` 文件：
  ```plaintext
  ENV_VAR1=value1
  ENV_VAR2=value2
  ```

  `docker-compose.yml`:
  ```yaml
  version: '3.8'

  services:
    app:
      image: myapp
      env_file:
        - ./env.list
  ```

4. 覆盖关系

- **`environment` 覆盖 `env_file`**：
  - 在同一个服务中，如果 `environment` 和 `env_file` 都定义了相同的变量，`environment` 配置具有更高的优先级并会覆盖来自 `env_file` 的设置。

- **覆盖示例**：

  假设 `env.list` 文件内容是：
  ```plaintext
  APP_ENV=production
  DEBUG=false
  ```

  `docker-compose.yml` 文件为：
  ```yaml
  version: '3.8'

  services:
    app:
      image: myapp
      env_file:
        - ./env.list
      environment:
        APP_ENV: development  # 覆盖 env_file 
        EXTRA_VAR: extra_value
  ```

  在这个例子中，`APP_ENV` 的值将是 `development`，因为在 `environment` 中的定义覆盖了 `env_file` 中的定义。
