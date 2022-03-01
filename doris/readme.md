# build
[build](https://doris.apache.org/zh-CN/installing/compilation.html#%E4%BD%BF%E7%94%A8-docker-%E5%BC%80%E5%8F%91%E9%95%9C%E5%83%8F%E7%BC%96%E8%AF%91-%E6%8E%A8%E8%8D%90)
# 启动失败
1. 删除`doris-meta`文件夹
2. be.conf fe.conf 增加`priority_networks = 172.19.199.0/24`
# 通过mysql链接
[mysql client下载链接](https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.37-winx64.zip)
```
.\mysql.exe -P9030 -uroot
```

# 其他sql
```sql
SHOW PROC '/frontends';
SHOW PROC '/backends';
ALTER SYSTEM ADD BACKEND "host:port";
ALTER SYSTEM ADD FOLLOWER "host:port";
ALTER SYSTEM ADD OBSERVER "host:port";
ALTER SYSTEM DECOMMISSION BACKEND "be_host:be_heartbeat_service_port";
```
```sql
.\mysql.exe -P9030 -uroot
ALTER SYSTEM ADD BACKEND "172.19.199.3:9050";
CREATE USER 'longfengpili'@'%' IDENTIFIED BY 'xcy@123456';
GRANT all ON *.* TO 'longfengpili'@'%';
CREATE DATABASE fact_10001123_15;
CREATE DATABASE fact_20000063_08;
```