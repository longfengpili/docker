# docker run
```docker
docker run --name mynginx -p 80:80 \
-v /home/longfengpili/nginx/nginx.conf:/etc/nginx/nginx.conf \
-v /home/longfengpili/nginx/logs:/var/log/nginx/ \
-v /home/longfengpili/nginx/default.conf:/etc/nginx/conf.d/default.conf \
-d nginx
```
