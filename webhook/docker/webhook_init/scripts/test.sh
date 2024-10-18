#!/bin/bash

# 获取命令行参数
arg1=\$1
arg2=\$2

# 获取环境变量
static_env_value=$ENV_VAR
payload_env_value=$payloadEnvVar

# 读取文件内容
if [ -f "$PAYLOAD_FILE" ]; then
    file_content=$(cat "$PAYLOAD_FILE")
else
    file_content="File not found"
fi

# 打印获取到的参数和环境变量
echo "Argument 1: $arg1"
echo "Argument 2: $arg2"
echo "Static Env Var (ENV_VAR): $static_env_value"
echo "Payload Env Var (payloadEnvVar): $payload_env_value"
echo "File Content: $file_content"
