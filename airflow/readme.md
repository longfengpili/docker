# 开启登陆权限
+ 修复airflow.cfg文件
```
[webserver]
security = Flask AppBuilder
secure_mode = True
rbac=True
```
>注意：如果在[webserver]里面有 authenticate 和 auth_backend 的配置，就必须先将其注释掉了
+ 在命令行执行
```
airflow create_user -r Admin -u longfengpili -e 398745129@qq.com -f chunyang -l xu -p 123456abc
```

# UI CLI 参数方法
```
kwargs.get('dag_run').conf
```
