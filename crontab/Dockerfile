FROM ubuntu:latest
MAINTAINER chunyang

RUN apt-get update && apt-get -y install cron vim

# Add crontab file in the cron directory
ADD hello-cron /etc/cron.d/hello-cron

# Give execution rights on the cron job
RUN chmod 644 /etc/cron.d/hello-cron

# Apply cron job
RUN crontab /etc/cron.d/hello-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
