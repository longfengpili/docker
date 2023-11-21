#!/bin/bash

if [ -z "$(ls -A "$NAMEDIR")" ]; then
  echo "Formatting namenode name directory: $NAMEDIR"
  hdfs namenode -format
fi

echo "Starting Hadoop name node..."
hdfs --daemon start namenode

#echo "Starting Hadoop secondary name node..."
#hdfs --daemon start secondarynamenode

echo "Starting Hadoop resource manager..."
yarn --daemon start resourcemanager

if [ ! -f "$NAMEDIR"/initialized ]; then
  echo "Configuring Hive..."
  hdfs dfs -mkdir -p  /user/hive/warehouse

  while true; do
    echo "尝试初始化 Hive..."

    # 执行命令
    schematool -dbType postgres -initSchema

    # 检查命令是否成功
    if [ $? -eq 0 ]; then
        echo "Hive 成功初始化。"
        break
    else
        echo "初始化 Hive 失败，重试中..."
    fi

    # 可选：在重试之前暂停
    sleep 5
  done

  touch "$NAMEDIR"/initialized
fi

echo "Starting Hive Metastore..."
hive --service metastore &

echo "Starting Hive server2..."
hiveserver2 &

if ! hdfs dfs -test -d /tmp
then
  echo "Formatting directory: /tmp"
  hdfs dfs -mkdir -p  /tmp
fi
if ! hdfs dfs -test -d "$SPARK_LOGS_HDFS_PATH"
then
  echo "Formatting directory: $SPARK_LOGS_HDFS_PATH"
  hdfs dfs -mkdir -p  "$SPARK_LOGS_HDFS_PATH"
fi
if ! hdfs dfs -test -d "$SPARK_JARS_HDFS_PATH"
then
  echo "Formatting directory: $SPARK_JARS_HDFS_PATH"
  hdfs dfs -mkdir -p  "$SPARK_JARS_HDFS_PATH"
  hdfs dfs -put "$SPARK_HOME"/jars/* "$SPARK_JARS_HDFS_PATH"/
fi

echo "Starting Spark master node..."
spark-class org.apache.spark.deploy.master.Master --ip "$SPARK_MASTER_HOST"
