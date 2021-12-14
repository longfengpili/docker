/*
* @Author: chunyang.xu
* @Date:   2020-03-19 15:20:22
* @Last Modified by:   chunyang.xu
* @Last Modified time: 2021-07-05 17:48:38
*/

use mysql;

-- mysql 8.0
create user 'longfengpili' identified WITH mysql_native_password by '123456abc';
-- 将数据库的权限授权给创建的longfengpili用户
grant all on *.* to 'longfengpili';

-- 这一条命令一定要有：
-- flush privileges;

set global explicit_defaults_for_timestamp = 1;
select host, user from user;
