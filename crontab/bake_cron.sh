#!/bin/bash
# 每天对crontab 进行备份 ，同时删除最近15天的数据
DATE=$(date +%Y%m%d)

crontab -l >>/home/longfengpili/bake_cron/crontab_$DATE.bak
find /home/longfengpili/bake_cron/ -name *.bak -mtime +7 -exec rm {} \;
