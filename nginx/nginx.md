# docker run
```docker
docker run --name mynginx -p 80:80 \
-v /home/longfengpili/nginx/nginx.conf:/etc/nginx/nginx.conf \
-v /home/longfengpili/nginx/logs:/var/log/nginx/ \
-v /home/longfengpili/nginx/default.conf:/etc/nginx/conf.d/default.conf \
-d nginx
```

# https
![](https://cloud.tencent.com/document/product/400/35244)
```docker
docker run --name nginx_https -p 443:443 \
-v /home/longfengpili/nginx_https/nginx.conf:/etc/nginx/nginx.conf \
-v /home/longfengpili/nginx_https/1_longfengpili.xyz_bundle.crt:/etc/nginx/1_longfengpili.xyz_bundle.crt \
-v /home/longfengpili/nginx_https/2_longfengpili.xyz.key:/etc/nginx/2_longfengpili.xyz.key \
-v /home/longfengpili/nginx_https/default.conf:/etc/nginx/conf.d/default.conf \
nginx
```
