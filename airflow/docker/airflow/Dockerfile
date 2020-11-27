FROM python:3.7
MAINTAINER chunyang

ENV AIRFLOW_HOME=/airflow
#增加中文编码
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8
# 设置环境
ENV TZ=Asia/Shanghai

#change timezone
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install tzdata && echo $TZ > /etc/timezone && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# install 
RUN pip install -U pip setuptools wheel && pip install apache-airflow[mysql]

# set workspace
RUN mkdir -p ${AIRFLOW_HOME}
WORKDIR ${AIRFLOW_HOME}

# start
ENTRYPOINT ["./entrypoint.sh"]
CMD ["webserver"]

# docker run --name myairflow -v /e/github/docker/airflow/airflow:/airflow -p 8080:8080 myairflow
