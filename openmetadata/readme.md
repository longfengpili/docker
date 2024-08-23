# data quality
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
