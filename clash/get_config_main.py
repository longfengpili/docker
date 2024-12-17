# -*- coding: utf-8 -*-
# @Author: longfengpili
# @Date:   2024-12-17 14:09:04
# @Last Modified by:   longfengpili
# @Last Modified time: 2024-12-17 14:19:52
# @github: https://github.com/longfengpili


import yaml

from free_clash.get_free.get_free import GetFreeProxies
from free_clash.models.clash import ClashConfig

file = './clash/config.yaml'

gfp = GetFreeProxies()
res = gfp.get_clash()

config = ClashConfig.load_from_yaml(res)

proxies = config.get_proxies('cipher', type='vless')
config['proxies'] = proxies

proxy_groups = config.get_proxy_groups('cipher', type='vless')
config['proxy-groups'] = proxy_groups

data = config.dump_file(file)
