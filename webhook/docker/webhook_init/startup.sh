#!/bin/bash

# 如果本地目录为空，则从容器复制文件到本地目录
if [ -z "$(ls -A /webhook/config)" ]; then
   cp -r /webhook_init/config/* /webhook/config/
fi

if [ -z "$(ls -A /webhook/scripts)" ]; then
   cp -r /webhook_init/scripts/* /webhook/scripts/
fi

# 执行 webhook 应用
exec /usr/local/bin/webhook "$@"
