FROM ubuntu:latest
MAINTAINER chunyang

#language-pack-zh-hans support zh
RUN apt-get update -y && apt-get -y install cron && apt-get -y install python3.6 python3-pip && apt-get -y install language-pack-zh-hans

#增加中文编码
RUN locale-gen zh_CN.UTF-8  
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/crontab

# Give execution rights on the cron job
RUN chmod 744 /etc/cron.d/crontab

# Apply cron job
RUN crontab /etc/cron.d/crontab

# Create the log file to be able to run tail
RUN touch /var/log/cron.log && touch /var/log/py.log

# Create WorkDir
WORKDIR /workspace/

#Copy requirements
COPY requirements.txt ./requirements.txt

#Pip
RUN pip3 install -r requirements.txt

#change timezone
RUN apt-get install tzdata && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log




