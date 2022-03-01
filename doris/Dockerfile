FROM ubuntu:latest
MAINTAINER chunyang

USER root

#language-pack-zh-hans support zh
RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && apt-get clean

# 设置环境
ENV TZ=Asia/Shanghai

#change timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y && apt-get -y install build-essential manpages-dev openjdk-11-jdk language-pack-zh-hans mysql-client
RUN apt-get -y install tzdata && dpkg-reconfigure --frontend noninteractive tzdata

#增加中文编码
RUN locale-gen zh_CN.UTF-8  
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
