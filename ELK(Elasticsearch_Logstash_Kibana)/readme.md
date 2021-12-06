# 使用方法
+ `docker-compose up -d`启动
+ 打开kibana[http://127.0.0.1:5601/](http://127.0.0.1:5601/), 密码默认：elastic/changeme
+ `Management → Stack Management → Logstash管道`, 创建管道, 具体参考下面管道创建方法
+ `Management → Stack Management → 索引模式`, 创建索引
+ `Analytics → Discovery` 查看数据。


# filter
## md5
```
ruby {
      code => "
        require 'digest/md5'
        md5 = Digest::MD5.hexdigest(event.get('json_log'))
        event.set('computed_id', md5)
        "
    }
```

# mysql java 驱动
+ 不要放到pipline里，会报错
+ 下载地址：https://downloads.mysql.com/archives/c-j/, 8.0.13版本支持mysql5.0、8.0

# 索引字段设置
+ `Management → 索引管理 → 索引 → 编辑设置`, `"index.mapping.total_fields.limit": "10000"`

# Logstash config
## input [官方 input](https://www.elastic.co/guide/en/logstash/current/input-plugins.html)
+ mysql [jdbc](https://www.elastic.co/guide/en/logstash/current/plugins-inputs-jdbc.html)(可以直接在logstash.conf里设置)
```
input {
    stdin {}
    jdbc {
        jdbc_connection_string => "jdbc:mysql://xxxx:9030/logs_20000062_11?characterEncoding=utf8&useSSL=false&serverTimezone=UTC&rewriteBatchedStatements=true"
        jdbc_user => "xxxx"
        jdbc_password => "xxx"
        jdbc_driver_library => "/etc/logstash/mysql-connector-java-8.0.13.jar"
        jdbc_driver_class => "com.mysql.cj.jdbc.Driver"
        #开启分页查询
        jdbc_paging_enabled => false
        jdbc_page_size => 5000
        parameters => { "uni_deviceid" => "d69145c567e8ff8caebbbf4b99b32144"}
        statement => "select * from server_playcrab_event_data where uni_deviceid = :uni_deviceid and time >= :sql_last_value and time < DATE_ADD(:sql_last_value, interval 1 day) order by time asc"
        use_column_value => true
        tracking_column_type => "timestamp"
        tracking_column => "time"
        record_last_run => "true"
        last_run_metadata_path => "/etc/logstash/record_last_run"
        clean_run => false
        schedule => "* * * * *"
    }
}
```

## 解析json和data
```
filter {
 
    json {
        source => "json_log"
    }
    date {
        match => ["timemilis", "yyyy-MM-dd HH:mm:ss", "UNIX_MS"]
        target => "@timestamp"
    }
 
}
```
 
## output
```
output {
    elasticsearch {
        hosts => "elasticsearch:9200"
        user => "elastic"
        password => "changeme"
        ecs_compatibility => disabled
        index => "mu3-%{+YYYY.MM.dd}"
    }
}
```

