# Hadoop-Hive-Spark 集群 + Jupyter in Docker

## 介绍
Hive、Hadoop 和 Spark 是三个常见且功能各异的大数据技术，它们在处理大规模数据集时各有特点和应用场景。

### Hadoop

Hadoop 是一个开源框架，用于可靠、可伸缩、分布式计算。它由两个主要组件组成：

1. **HDFS (Hadoop Distributed File System)**：一种分布式文件系统，提供高吞吐量的数据访问，非常适合带有大数据集的应用程序。
2. **MapReduce**：一种编程模型，用于并行处理大量数据。在 Hadoop 生态系统中，MapReduce 处理数据的任务分为两个阶段：Map 阶段和 Reduce 阶段。

Hadoop 的优势在于其能够处理非常大的数据集，并且是构建其他大数据技术（如 Hive 和 Spark）的基础。

### Hive

Hive 是构建在 Hadoop 之上的数据仓库工具，用于数据摘要、查询和分析。它的主要特点包括：

1. **SQL-like 查询语言（HiveQL）**：允许用户编写类似于 SQL 的查询语句来操作存储在 HDFS 中的数据。
2. **将查询转换为 MapReduce 任务**：Hive 将 HiveQL 查询转换为 MapReduce 任务，使得即使不熟悉 MapReduce 编程模型的用户也能够处理大规模数据。
3. **用于数据仓库的特性**：如分区、索引和存储管理等，这些特性优化了大规模数据的存储和查询。

Hive 的优势在于提供了一种高级的、类 SQL 的接口来查询数据，使得数据分析更加便捷。

### Spark

Spark 是一个开源的、快速的、用于大规模数据处理的统一分析引擎。它有以下几个主要特点：

1. **内存计算**：Spark 主要将数据保留在内存中，这比传统的基于磁盘的技术（如 MapReduce）快得多。
2. **通用性**：Spark 支持 SQL 查询、流数据处理、机器学习和图形处理等多种大数据处理模式。
3. **易用性**：提供了 Scala、Java、Python 和 R 的 API，使得编写并行应用程序变得简单。

Spark 的优势在于其快速的数据处理能力和多样的数据处理方式。它非常适合于需要快速迭代数据处理任务的场景，例如机器学习。

### 总结

- **Hadoop** 主要用于大规模数据存储和批处理。
- **Hive** 基于 Hadoop，提供了一种高级、类 SQL 的查询接口，使得用户可以通过类似于 SQL 的语言查询大数据。
- **Spark** 是一个通用的大数据处理框架，特别擅长于快速处理和迭代分析，可以处理批处理和实时数据流。

这三个技术常常被一起使用，以发挥各自的优势，解决复杂的大数据问题。例如，可以在 Spark 中使用 Hive 来查询存储在 Hadoop 分布式文件系统上的数据。

## 组件

* [Hadoop 3.3.4](https://hadoop.apache.org/)

* [Hive 3.1.3](http://hive.apache.org/)

* [Spark 3.3.1](https://spark.apache.org/)

## 启动

要启动集群，需要依次执行以下命令：
```
docker build -t hadoop-hive-spark-base ./base
docker build -t hadoop-hive-spark-master ./master
docker build -t hadoop-hive-spark-worker ./worker
docker build -t hadoop-hive-spark-history ./history
docker build -t hadoop-hive-spark-jupyter ./jupyter
docker-compose up -d
```

## Docker Compose 配置文件

`master` 服务配置了多个端口映射。这些端口映射允许您从 Docker 容器外部（比如宿主机或网络上的其他机器）访问这些服务。下面是对 `master` 服务中每个端口映射的详细说明：
1. **4040**: Spark 应用的 Web UI 端口。Spark 使用这个端口来提供运行中的应用程序的信息。
2. **8020**: Hadoop NameNode IPC 端口。这是 Hadoop 文件系统的客户端与 NameNode 通信的端口。
3. **8080**: Spark Master 的 Web UI 端口。这个界面提供了关于 Spark 集群状态的信息，如当前的作业、可用的执行器等。
4. **8088**: YARN 资源管理器的 Web UI 端口。如果您的 Hadoop 配置使用 YARN 作为资源管理器，这个界面会提供有关集群资源使用情况的信息。
5. **9870**: Hadoop HDFS NameNode 的 Web UI 端口。这个界面提供了关于 HDFS 状态的信息，如文件系统的健康状况、存储使用情况等。
6. **10000**: HiveServer2 的默认端口。这个端口用于与 Hive 客户端通信，如 JDBC/ODBC 连接。


## 服务可以通过以下链接访问：

### 注意事项

- 在部署和访问这些服务时，请确保没有任何网络安全策略（如防火墙规则）阻止对这些端口的访问。
- 如果您的宿主机上已经有服务占用了这些端口，您可能需要调整映射到宿主机的端口号以避免冲突。

### Hadoop

资源管理器：http://localhost:8088

名称节点：http://localhost:9870

历史服务器：http://localhost:19888

数据节点1：http://localhost:9864
数据节点2：http://localhost:9865

节点管理器1：http://localhost:8042
节点管理器2：http://localhost:8043

### Spark
任务节点：http://localhost:4040

主节点：http://localhost:8080

工作节点1：http://localhost:8081
工作节点2：http://localhost:8082

历史记录：http://localhost:18080

### Hive
URI：jdbc:hive2://localhost:10000

### Jupyter 笔记本
URL：http://localhost:18888

示例：[jupyter/notebook/pyspark.ipynb](jupyter/notebook/pyspark.ipynb)

