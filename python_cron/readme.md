<!--
 * @Author: longfengpili
 * @Date: 2019-10-13 10:33:02
 * @LastEditTime: 2019-10-13 10:47:06
 * @github: https://github.com/longfengpili
 -->
 
# volume
>需要注意路径（检查路径）

 ```docker
docker run --name mypython -v E:/github/docker/python_cron/crontabfile/:/etc/cron.d/ -v E:/GoogleDrive/work_daily/daily_work/bi_daily_job/:/workspace/ python_cron:v7
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
# 环境变量的问题
>cron并不会获取当前用户的所有环境变量，可疑考虑直接在sh中设置环境变量
```bash
export PATH="/usr/bin/phantomjs:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export QT_QPA_PLATFORM="offscreen"
```

# 工作目录的问题
>避免代码中写的是相对路径，最好在sh中cd到工作目录，保证代码稳健