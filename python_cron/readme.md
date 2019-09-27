# volume
 ```docker
docker run -e TZ="Asia/Shanghai" --name mycron_v1 -v e:/GoogleDrive/work_daily/github/docker/python_cron/code:/workspace/job/ mycron_py:v1
 ```
# TZ
>  # 创建并运行容器，通过 -e TZ="Asia/Shanghai" 设置时区
     ```docker
     docker run -e TZ="Asia/Shanghai" -d -p 80:80 --name nginx nginx
     ```