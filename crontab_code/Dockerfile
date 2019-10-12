FROM ubuntu:latest
MAINTAINER chunyang

RUN apt-get update -y && apt-get -y install cron vim

# 设置环境
ENV TZ=Asia/Shanghai

#change timezone
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install tzdata && echo "Asia/Shanghai" > /etc/timezone && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# Add crontab file in the cron directory
ADD /crontabfile/hello-cron /etc/cron.d/hello-cron

# Give execution rights on the cron job
RUN chmod 644 /etc/cron.d/hello-cron

# Apply cron job
RUN crontab /etc/cron.d/hello-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
