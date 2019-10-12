# volume
 ```docker
docker run --name python_cron -v E:\GoogleDrive\work_daily\github\docker\python_cron\crontabfile:/etc/cron.d/ -v E:\GoogleDrive\work_daily\daily_work:/workspac e/ python_cron:v3
 ```
# TZ
>  # 创建并运行容器，通过 -e TZ="Asia/Shanghai" 设置时区
     ```docker
     docker run -e TZ="Asia/Shanghai" -d -p 80:80 --name nginx nginx
     ```

# volume
```
docker run -it -v e:\googledrive\work_daily\github\docker\crontab_t:/etc/cron.d/ -v E:\GoogleDrive\work_daily\github\docker\crontab_t\code:/code/ --name cron_t cron_t:latest bash
```

#crontab
+ crontab 文件修改需要重新加载
```
crontab /etc/cron.d/hello-cron
```