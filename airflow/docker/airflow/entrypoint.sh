#!/bin/bash

# @Author: chunyang.xu
# @Date:   2020-11-24 14:37:42
# @Last Modified by:   chunyang.xu
# @Last Modified time: 2020-11-27 12:28:19

airflow initdb
airflow scheduler &
# airflow flower &
exec airflow "$@"
