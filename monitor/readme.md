# 监控服务器性能
# 部署prometheus、grafana
```
docker-compose up -d
```
# prometheus配置
```
# 我的全局配置
global:
  scrape_interval: 15s # 设置抓取间隔为每15秒。默认是每1分钟。
  evaluation_interval: 15s # 每15秒评估一次规则。默认是每1分钟。

# Alertmanager 配置
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# 加载规则文件并根据全局 'evaluation_interval' 定期评估它们。
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# 包含一个要抓取端点的抓取配置：
# 这里是 Prometheus 自己。
scrape_configs:
  # 工作名称作为标签 `job=<job_name>` 被添加到从此配置抓取的任何时间序列中。
  - job_name: "prometheus"

    # metrics_path 默认为 '/metrics'
    # scheme 默认为 'http'。

    static_configs:
      - targets: ["localhost:9090"]


```

# 部署node_exporter(监控服务器)
1. 建立容器
```bash
docker-compose -f docker-compose-nodeexporter.yml up -d
```
2. 访问确认
```
curl ip:9100
```
3. prometheus配置中增加
```yaml
  - job_name: 'node2.156'
    static_configs:
      - targets: ['ip:9100']
```

# trino monitor
1. 下载jmx_prometheus_javaagent
```base
mkdir jmx-exporter
wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.19.0/jmx_prometheus_javaagent-0.19.0.jar -O jmx-exporter/jmx_prometheus_javaagent-0.19.0.jar
```

2. 创建jmx 配置文件，可以设置采集规则，默认是采集所有指标
```bash
touch jmx-exporter/jmx_config.yaml
```
```yaml
rules:
- pattern: ".*"
```

3. trino修改jvm.config配置(path替换实际路径)
```config
-javaagent:/path/jmx_prometheus_javaagent-0.19.0.jar=3900:/path/jmx_config.yaml
```
4. 访问确认
```
curl localhost:3900
```
5. prometheus配置中增加
```yaml
  - job_name: 'trino'
    static_configs:
      - targets: ['host:3900']
```
