# start
```bash
docker-compose -f docker-compose-postgres.yml -f docker-compose-company.yml up -d
```

# data quality
+ [docker compose](https://github.com/open-metadata/OpenMetadata/releases)
+ Strategy
    + count
        + 如果返回的是int，那么则显示具体的数值
        + 如果返回的是str，那么则显示的是字符串的长度
        + 其他的数据类型可能会出现错误
        ```sql
        with user_info_count as (
        select count(1) as count
        from hive.blockwar_om_w.dws_user_info_di
        ),

        merge_base_count as (
            select count(distinct role_id) as count
            from hive.blockwar_om_r.dwd_merge_base_live
        )

        select abs(user_info_count.count - merge_base_count.count) / user_info_count.count * 1000 as result
        from user_info_count, merge_base_count

        ```
    + rows
        + 返回行数，并在openmetadata中计算
        ```sql
        select role_id, count(1) from hive.blockwar_om_w.dws_user_info_di
        group by 1
        having count(1) > 1
        ```

# openmetadata_ingestion error
```
File "/home/airflow/.local/lib/python3.10/site-packages/gunicorn/workers/workertmp.py", line 45, in notify
os.utime(self._tmp.fileno(), (new_time, new_time))
FileNotFoundError: [Errno 2] No such file or directory
```
解决方案：
```
docker exec -it -uroot openmetadata_ingestion bash
apt update
apt install vim
vim /home/airflow/.local/lib/python3.10/site-packages/gunicorn/workers/workertmp.py
```

```
def notify(self):
    new_time = time.monotonic()
    try:
        os.utime(self._tmp.fileno(), (new_time, new_time))
    except Exception as e:
        print(e)
```