# [加载示例数据](https://www.elastic.co/guide/en/kibana/7.9/tutorial-build-dashboard.html)
## 设置索引  
```
PUT /shakespeare
{
  "mappings": {
    "properties": {
    "speaker": {"type": "keyword"},
    "play_name": {"type": "keyword"},
    "line_id": {"type": "integer"},
    "speech_number": {"type": "integer"}
    }
  }
}

PUT /rum
{
  "mappings": {
    "properties": {
      "ts": {
        "type": "date",
        "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_second"
      },
      "sts": {
        "type": "date",
        "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_second"
      },
      "attrs": {
        "properties": {
          "ts": {
            "type": "date",
            "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis"
          },
          "sts": {
            "type": "date",
            "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis"
          }
        }
      }
    }
  }
}

PUT /logstash-2015.05.18
{
  "mappings": {
    "properties": {
      "geo": {
        "properties": {
          "coordinates": {
            "type": "geo_point"
          }
        }
      }
    }
  }
}

GET /_cat/indices?v
```

## 导入数据(logs文件太大，分开导入)
```
curl -H "Content-Type: application/x-ndjson" -XPOST "localhost:9200/bank/_bulk?pretty" --data-binary @accounts.json
curl -H "Content-Type: application/x-ndjson" -XPOST "localhost:9200/shakespeare/_bulk?pretty" --data-binary @shakespeare.json
curl -H "Content-Type: application/x-ndjson" -XPOST "localhost:9200/_bulk?pretty" --data-binary @logs.jsonl
curl -H "Content-Type: application/x-ndjson" -XPOST "localhost:9200/_bulk?pretty" --data-binary @logs.jsonl1
```

## 设置密码
```
docker-compose exec es01 /usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive
```

# 启用Xpack
[Elasticsearch：设置 Elastic 账户安全](https://elasticstack.blog.csdn.net/article/details/100548174)
[单机版elasticsearch-7.x使用xpack进行安全认证](http://www.eryajf.net/3500.html)
