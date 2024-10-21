FROM ubuntu:latest
LABEL maintainer="chunyang"

# Docker 内用户切换到 root
USER root

# 设置环境变量，以支持中文
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8

# 设置容器的时区为东八区，即北京时间
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 更新系统包列表并安装
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y locales wget cron git python3-pip \
    && locale-gen zh_CN.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/crontab

# Give execution rights on the cron job
RUN chmod 777 /etc/cron.d/crontab

# Apply cron job
RUN crontab /etc/cron.d/crontab

# Create WorkDir
WORKDIR /workspace/

#Copy requirements
COPY requirements.txt ./requirements.txt

#Pip
RUN pip3 install --break-system-packages -i https://mirrors.ustc.edu.cn/pypi/web/simple -r requirements.txt

# Run the command on container startup
CMD cron && crontab /etc/cron.d/crontab && tail -f /dev/null
