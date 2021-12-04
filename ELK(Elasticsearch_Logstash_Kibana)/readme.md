# 使用方法
+ `docker-compose up -d`启动
+ 打开kibana[http://127.0.0.1:5601/](http://127.0.0.1:5601/), 密码默认：elastic/changeme
+ `Management → Stack Management → Logstash管道`, 创建管道, 具体参考下面管道创建方法
+ `Management → Stack Management → 索引模式`, 创建索引
+ `Analytics → Discovery` 查看数据。

# 创建管道
+ mysql(可以直接在logstash.conf里设置)
```
input {
    stdin {}
    jdbc {
        jdbc_connection_string => "jdbc:mysql://xxxxxxx:9030/logs_20000063_08"
        jdbc_user => "xx"
        jdbc_password => "xx"
        jdbc_driver_library => "/etc/logstash/mysql-connector-java-8.0.13.jar"
        jdbc_driver_class => "com.mysql.jdbc.Driver"
        #开启分页查询
        jdbc_paging_enabled => true
        jdbc_page_size => 5000
        use_column_value => true
        tracking_column => "time"
        tracking_column_type => "timestamp"
        record_last_run => true
        last_run_metadata_path => "/etc/logstash/record_last_run.txt"
        statement => "select * from server_ctlog where time > :sql_last_value order by time asc"
        clean_run => "false"
        schedule => "* * * * *"
    }
}

filter {
 
    json {
        source => "json_log"
    }
    date {
        match => ["time", "yyyy-MM-dd HH:mm:ss"]
        target => "@timestamp"
    }
 
}
  
output {
    stdout {
        codec => json_lines
    }
    elasticsearch {
        hosts => "elasticsearch:9200"
        user => "elastic"
        password => "changeme"
        ecs_compatibility => disabled
        index => "mu3-%{+YYYY.MM.dd}"
    }
}
```


# mysql java 驱动
+ 不要放到pipline里，会报错
+ 下载地址：https://downloads.mysql.com/archives/c-j/, 8.0.13版本支持mysql5.0、8.0
