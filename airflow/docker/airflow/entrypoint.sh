#!/bin/bash

# @Author: chunyang.xu
# @Date:   2020-11-24 14:37:42
# @Last Modified by:   chunyang.xu
# @Last Modified time: 2020-11-27 18:22:28

# 初始化数据库
airflow initdb

# 创建管理员帐号
airflow create_user -r Admin -u longfengpili -e 398745129@qq.com -f chunyang -l xu -p 123456abc

# 启动调度
airflow scheduler &

# 启动
exec airflow "$@"
