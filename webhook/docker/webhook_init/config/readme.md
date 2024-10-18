+ [Hook definition](https://github.com/adnanh/webhook/blob/master/docs/Hook-Definition.md)
    - id: redeploy-webhook 是这个 Hook 的标识符。
    - execute-command: /etc/webhook/test.sh 是当 Hook 被触发时要执行的命令。
    - command-working-directory: /etc/webhook 是命令执行时的工作目录。
    - response-message: 返回给 Hook 发起者的消息。
    - response-headers: 一个包含自定义 HTTP 头的列表。
    - success-http-response-code: 成功时返回的 HTTP 状态码。
    - incoming-payload-content-type: 设置传入请求的内容类型。
    - http-methods: 允许的 HTTP 方法，这里只允许 POST 请求。
    - include-command-output-in-response: 是否等待命令完成并将输出返回给 Hook 发起者。
    - include-command-output-in-response-on-error: 在命令执行失败时是否包含标准输出和错误信息。
    - pass-arguments-to-command: 传递给命令的参数列表。
    - pass-environment-to-command: 作为环境变量传递给命令的参数列表。
    - pass-file-to-command: 传递给命令的文件列表。
    - trigger-rule: 触发 Hook 的规则，在这里它检查 URL 中的 token 参数和 payload 中的 event 参数。
    - trigger-rule-mismatch-http-response-code: 当触发规则不满足时返回的 HTTP 状态码。
    - trigger-signature-soft-failures: 允许在 Or 规则中软失败。

+ example:
```python
import requests
import json
import base64

# 定义目标 URL（根据实际情况替换）
url = "http://localhost:9000/hooks/redeploy-webhook"

# 定义静态和动态数据
static_value = "static-value"
dynamic_value = "dynamic-value"
dynamic_env_value = "dynamic-env-value"
file_content = "Hello, World!"

# 将文件内容编码为 base64
encoded_file_content = base64.b64encode(file_content.encode()).decode()

# 构建 payload
payload = {
    "some": {
        "json": {
            "path": dynamic_value
        }
    },
    "some": {
        "other": {
            "path": dynamic_env_value
        }
    },
    "file": {
        "path": encoded_file_content
    }
}

# 设置自定义头部
headers = {
    "Content-Type": "application/json",
    "X-Example-Header": "it works"
}

# 发送 POST 请求
response = requests.post(url, headers=headers, data=json.dumps(payload))

# 打印响应
print(f"Status Code: {response.status_code}")
print(f"Response Body: {response.text}")

```