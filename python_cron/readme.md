# volume
 ```docker
docker run -e TZ="Asia/Shanghai" --name mycron_v1 -v e:/GoogleDrive/work_daily/github/docker/python_cron/code:/workspace/job/ mycron_py:v1
 ```
# TZ
>  # 创建并运行容器，通过 -e TZ="Asia/Shanghai" 设置时区
     ```docker
     docker run -e TZ="Asia/Shanghai" -d -p 80:80 --name nginx nginx
     ```

# volume
```
docker run -it -v e:\googledrive\work_daily\github\docker\crontab_t\hello-cron:/etc/cron.d/hello-cron -v E:\GoogleDrive\work_daily\github\docker\crontab_t\code\:/code/ --na me cron_t cron_t:latest bash
```

# cron
> 第一次使用exec进入需要重启cron    
```
/etc/init.d/cron restart
```