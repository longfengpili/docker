FROM ubuntu:latest
MAINTAINER chunyang

USER root

#language-pack-zh-hans support zh
RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && apt-get clean
RUN apt-get update -y && apt-get -y install cron python3.8 python3-pip language-pack-zh-hans git

#增加中文编码
RUN locale-gen zh_CN.UTF-8  
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8

# 设置环境
ENV TZ=Asia/Shanghai

#change timezone
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install tzdata && echo "Asia/Shanghai" > /etc/timezone && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/crontab

# Give execution rights on the cron job
RUN chmod 777 /etc/cron.d/crontab

# Apply cron job
RUN crontab /etc/cron.d/crontab

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Create WorkDir
WORKDIR /workspace/

#Copy requirements
COPY requirements.txt ./requirements.txt

#Pip
RUN pip3 install -i https://pypi.doubanio.com/simple/ -r requirements.txt

# Run the command on container startup
CMD env > /etc/default/locale && cron && crontab /etc/cron.d/crontab && tail -f /var/log/cron.log