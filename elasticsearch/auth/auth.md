# Elasticsearch 认证插件选择
这里选择一个免费的：社区插件 Readonly REST
下载地址：[https://readonlyrest.com/download/](https://readonlyrest.com/download/)
1、进入网站后 选择插件类型、elastic版本、邮箱地址
2、提交后下载地址会发送到你的邮箱

# 编写readonlyrest.yml
```yml
readonlyrest:
    access_control_rules:
    - name: "Require HTTP Basic Auth"
      type: allow
      auth_key: your user:your pwd
```

# 编写docker-compose.yml

# up
```docker
docker-compose up
```
