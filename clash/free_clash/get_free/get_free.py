# -*- coding: utf-8 -*-
# @Author: longfengpili
# @Date:   2024-12-13 11:23:42
# @Last Modified by:   longfengpili
# @Last Modified time: 2024-12-13 11:28:14
# @github: https://github.com/longfengpili


from .myrequests import BRequests


class GetFreeProxies:

    def __init__(self):
        self.url = 'https://raw.githubusercontent.com/aiboboxx/clashfree/refs/heads/main/clash.yml'

    def get_clash(self):
        br = BRequests()
        res = br.request_api('get', self.url)
        return res

