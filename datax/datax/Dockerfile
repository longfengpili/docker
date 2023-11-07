# 基础镜像系统
FROM ubuntu:latest

# Docker 内用户切换到 root
USER root

# 设置时区为东八区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 更新系统包列表并安装
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y wget openjdk-8-jdk python3
    # && apt-get clean
    # && rm -rf /var/lib/apt/lists/*

# 切换到 /usr/local/ 目录下
WORKDIR /usr/local/
# RUN wget http://datax-opensource.oss-cn-hangzhou.aliyuncs.com/datax.tar.gz
ADD ./datax.tar.gz ./

# 创建配置文件存放用文件夹
RUN mkdir /jobs
WORKDIR /jobs

# 启动命令
ENTRYPOINT ["/usr/bin/python3", "/usr/local/datax/bin/datax.py", "/jobs/job.json"]
CMD [""]