# Clash 配置文件介绍

### 端口配置

```yaml
# 配置文件的端口
port: 7890
socks-port: 7891
redir-port: 7892
```

- **port**：HTTP 代理端口，Clash 将在该端口上监听 HTTP 代理请求。
- **socks-port**：SOCKS5 代理端口，Clash 将在该端口上监听 SOCKS5 代理请求。
- **redir-port**：透明代理端口，主要用于透明代理场景，比如在路由器上配置透明代理时使用。

### 网络配置

```yaml
# 允许局域网连接
allow-lan: true
```

- **allow-lan**：允许局域网设备连接到 Clash。如果设置为 `true`，则局域网内的设备可以通过 Clash 进行代理。

### 日志配置

```yaml
# 日志级别 (可选: silent, error, warning, info, debug)
log-level: info
```

- **log-level**：日志级别，表示 Clash 输出的日志详细程度。可选值有 `silent`（无日志）、`error`（仅错误日志）、`warning`（警告日志）、`info`（信息日志）和 `debug`（调试日志）。

### RESTful API 和 UI 配置

```yaml
# RESTful API 和 UI 的配置
external-controller: 127.0.0.1:9090
```

- **external-controller**：用于 RESTful API 的地址和端口，Clash 的外部控制接口将监听该地址和端口，用于与 Clash Dashboard 或其他管理工具通信。

### 运行模式

```yaml
mode: Rule
```

- **mode**：Clash 的运行模式。可选值有 `Rule`（规则模式）、`Global`（全局代理模式）和 `Direct`（直接连接模式）。这里选择了 `Rule` 模式，表示流量处理将基于定义的规则。

### API 鉴权

```yaml
# 添加API鉴权，登录clash需要使用下面自定义的密码认证，防止盗用
secret: '1111aaaxx'
Authorization: Bearer ${secret}
```

- **secret**：用于 RESTful API 的访问密钥，增加了 API 鉴权，防止未经授权的访问。
- **Authorization**：这是一个 HTTP 请求头，使用 `Bearer` 令牌进行身份验证。

### DNS 配置

```yaml
dns:
  enable: true
  ipv6: false
  nameserver:
    - 223.5.5.5
    - 180.76.76.76
    - 119.29.29.29
    - 117.50.11.11
    - 117.50.10.10
    - 114.114.114.114
    - https://dns.alidns.com/dns-query
    - https://doh.360.cn/dns-query
  fallback:
    - 8.8.8.8
    - tls://dns.rubyfish.cn:853
    - tls://1.0.0.1:853
    - tls://dns.google:853
    - https://dns.rubyfish.cn/dns-query
    - https://cloudflare-dns.com/dns-query
    - https://dns.google/dns-query
  fallback-filter:
    geoip: true
    ipcidr:
      - 240.0.0.0/4
      - 0.0.0.0/32
      - 127.0.0.1/32
    domain:
      - +.google.com
      - +.facebook.com
      - +.youtube.com
      - +.xn--ngstr-lra8j.com
      - +.google.cn
      - +.googleapis.cn
      - +.gvt1.com
```

- **enable**：启用 DNS 解析功能。
- **ipv6**：禁用 IPv6 支持，只使用 IPv4 进行解析。
- **nameserver**：主 DNS 服务器列表，包含多个公共 DNS 服务器和 DoH（DNS over HTTPS）服务器。
- **fallback**：备用 DNS 服务器列表，当主 DNS 服务器无法响应时，会使用这些备用服务器。
- **fallback-filter**：过滤备用 DNS 服务器的规则。
  - **geoip**：启用 GeoIP 过滤，只使用指定的 IP 地址范围。
  - **ipcidr**：指定 IP 范围，避免解析到这些范围内的 IP。
  - **domain**：指定要使用备用 DNS 服务器解析的域名，前面加上 `+` 表示严格匹配这些域名。

### 代理配置

```yaml
proxies:
  - name: 有效期2025/02/17,剩余:98.74GB
    type: trojan
    server: iplc-hk-beta1.trojanwheel.com
    port: 5001
    password: KSxcxYNsf7i103isiYxqems
    alpn:
      - h2
      - http/1.1
    skip-cert-verify: true
```

- **proxies**：定义代理服务器的列表。
  - **name**：代理的名称。
  - **type**：代理类型，这里是 `trojan`。
  - **server**：代理服务器地址。
  - **port**：代理服务器端口。
  - **password**：Trojan 代理的密码。
  - **alpn**：应用层协议协商列表，指定了 HTTP/2 和 HTTP/1.1。
  - **skip-cert-verify**：是否跳过证书验证。

### 代理组配置

```yaml
proxy-groups:
  - name: Proxy
    type: select
    proxies:
      - Auto
      - 有效期2025/02/17,剩余:98.74GB
  - name: Auto
    type: url-test
    url: http://www.gstatic.com/generate_204
    interval: 300
    proxies:
      - 有效期2025/02/17,剩余:98.74GB
```

- **proxy-groups**：定义代理组。
  - **name**：代理组名称。
  - **type**：代理组类型，可以是 `select`、`url-test`、`load-balance`、`fallback` 等。
    - **select**：手动选择代理。
    - **url-test**：根据 URL 测试延迟，自动选择延迟最低的代理。
  - **proxies**：代理组中的代理列表。
  - **url**：用于延迟测试的 URL，适用于 `url-test` 类型的代理组。
  - **interval**：测试间隔时间（单位：秒），适用于 `url-test` 类型的代理组。

### 规则配置

```yaml
rules:
  - DOMAIN-SUFFIX,ghcr.io,Proxy
  - DOMAIN-KEYWORD,googleapis.cn,Proxy
  - DOMAIN,safebrowsing.urlsec.qq.com,DIRECT
  - IP-CIDR,91.108.4.0/22,Proxy,no-resolve
  - GEOIP,CN,DIRECT
  - MATCH,Proxy
```

- **rules**：定义流量处理规则的列表。规则按顺序匹配，一旦找到匹配的规则，就会使用该规则处理流量。
  - **DOMAIN-SUFFIX**：匹配域名后缀。例如，`DOMAIN-SUFFIX,ghcr.io,Proxy` 表示所有以 `ghcr.io` 结尾的域名流量通过 `Proxy`。
  - **DOMAIN-KEYWORD**：匹配域名关键词。例如，`DOMAIN-KEYWORD,googleapis.cn,Proxy` 表示所有包含 `googleapis.cn` 的域名流量通过 `Proxy`。
  - **DOMAIN**：匹配特定域名。例如，`DOMAIN,safebrowsing.urlsec.qq.com,DIRECT` 表示 `safebrowsing.urlsec.qq.com` 这个域名流量直接访问。
  - **IP-CIDR**：匹配 IP 地址范围。例如，`IP-CIDR,91.108.4.0/22,Proxy,no-resolve` 表示 IP 地址在 `91.108.4.0/22` 网段内的流量通过 `Proxy`，并且不进行域名解析（`no-resolve`）。
  - **GEOIP**：匹配地理位置。例如，`GEOIP,CN,DIRECT` 表示地理位置在中国大陆的流量直接访问。
  - **MATCH**：匹配所有其他流量。例如，`MATCH,Proxy` 表示所有其他未匹配的流量通过 `Proxy`。

