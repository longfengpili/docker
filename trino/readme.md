# 安装和使用
## 安装trino获取对应配置
```bash
# 创建原始的trino
docker run --name trino_test trinodb/trino:412
# 拷贝
docker cp trinot:/etc/trino d:/docker/trino
# docker cp trinot://usr/lib/trino/plugin d:/docker/trino
```

## 安装测试环境
### create trino
```bash
# create network (可以单独建个网络)
docker network create -d bridge mytrion_net
# create trino
docker run --name mytrino -d -p 8080:8080 --network mytrion_net -v d:/docker/trino:/etc/trino trinodb/trino:412
```

### create mysql
```bash
docker run -p 3306:3306 --network mytrion_net --name mysql --restart=always --privileged=true -e MYSQL_ROOT_PASSWORD=123456 -d mysql:latest
```


## 配置mysql
+ 在`catalog`中创建`mysql.properties`
+ 在配置文件中增加mysql配置
```java
connector.name=mysql
connection-url=jdbc:mysql://172.18.0.3:3306
connection-user=longfengpili
connection-password=123456abc
```

