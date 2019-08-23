# -*- coding: utf-8 -*-
# @Author: chunyang.xu
# @Email:  398745129@qq.com
# @Date:   2019-08-20 16:39:09
# @Last Modified time: 2019-08-23 16:37:06

import time
while True:
	time.sleep(1)
	with open('/var/log/py.log', 'a+', encoding='utf-8') as f:
		f.write(f'{time.time()}, hello world! xu \n')



