<!--
 * @Author: longfengpili
 * @Date: 2019-10-13 10:33:02
 * @LastEditTime: 2019-10-13 10:47:06
 * @github: https://github.com/longfengpili
 -->
 
# volume
 ```docker
docker run --name python_cron -v E:\GoogleDrive\work_daily\github\docker\python_cron\crontabfile:/etc/cron.d/ -v E:\GoogleDrive\work_daily\daily_work:/workspace/ python_cron:v3
 ```
# TZ
>  创建并运行容器，通过 -e TZ="Asia/Shanghai" 设置时区
     ```docker
     docker run -e TZ="Asia/Shanghai" -d -p 80:80 --name nginx nginx
     ```

# crontab
> crontab 文件修改需要重新加载
```
crontab /etc/cron.d/hello-cron
```