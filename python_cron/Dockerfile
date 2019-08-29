FROM ubuntu:latest
MAINTAINER chunyang

RUN apt-get update -y && apt-get -y install cron && apt-get -y install python3.6

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/crontab

#ADD ./code /daily_work

# Give execution rights on the cron job
RUN chmod 744 /etc/cron.d/crontab

# Apply cron job
RUN crontab /etc/cron.d/crontab

# Create the log file to be able to run tail
RUN touch /var/log/cron.log && touch /var/log/py.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log




