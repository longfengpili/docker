@REM @Author: longfengpili
@REM @Date:   2023-11-20 18:40:29
@REM @Last Modified by:   longfengpili
@REM Modified time: 2023-12-27 10:53:54

@echo off

echo down docker
docker-compose down -v

echo reset storage
rm -rf .\volumes\storage
mkdir .\volumes\storage

echo reset config
rm -rf .\volumes\config
mkdir .\volumes\config

echo build docker
docker-compose up -d
