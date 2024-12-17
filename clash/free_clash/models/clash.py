# -*- coding: utf-8 -*-
# @Author: longfengpili
# @Date:   2024-12-13 11:29:41
# @Last Modified by:   longfengpili
# @Last Modified time: 2024-12-17 14:20:07
# @github: https://github.com/longfengpili

import yaml


class ClashConfig:
    ClashKeys = ['port', 'socks-port', 'allow-lan', 'mode', 'log-level', 'external-controller', 'dns', 'proxies', 'proxy-groups', 'rules']

    def __init__(self, **kwargs):
        self.kwargs = kwargs
        # 动态创建属性
        for key in kwargs.keys():
            setattr(self, key, kwargs[key])

    def __getitem__(self, key: str):
        return getattr(self, key)

    def __setitem__(self, key: str, value):
        return setattr(self, key, value)

    @classmethod
    def load_from_yaml(cls, yamltext: str):
        data = yaml.safe_load(yamltext)
        return cls(**data)

    @classmethod
    def load_from_yamlfile(cls, file: str):
        with open(file, 'r', encoding='utf-8') as f:
            data = yaml.safe_load(f)
            return cls(**data)

    def get(self, item: str):
        return getattr(self, item)

    def get_proxies(self, *dropkeys, **dropvalues):
        proxies = self.proxies
        for key in dropkeys:
            proxies = [proxy for proxy in proxies if key not in proxy]
        for k, v in dropvalues.items():
            proxies = [proxy for proxy in proxies if proxy.get(k) != v]
        return proxies

    def get_proxy_groups(self, *drop_proxy_keys, dropnames: list[str] = None, **drop_proxy_values):
        proxies = self.get_proxies(*drop_proxy_keys, **drop_proxy_values)
        pnames = [proxy['name'] for proxy in proxies]

        _proxy_groups = getattr(self, 'proxy-groups')
        if dropnames:
            _proxy_groups = [group for group in _proxy_groups if group['name'] not in dropnames]
        gnames = [group['name'] for group in _proxy_groups]

        names = gnames + ['REJECT', 'DIRECT'] + pnames

        proxy_groups = []
        for group in _proxy_groups:
            if 'proxies' in group:
                proxies = [name for name in group['proxies'] if name in names]
                group['proxies'] = proxies
            proxy_groups.append(group)

        return proxy_groups

    def combine(self, other, update_keys: list = None, combine_keys: list = None):
        def modify_other(other):
            proxies = other.get_proxies(type='vless')
            proxy_groups = other.get_proxy_groups(type='vless')
            other['proxies'] = proxies
            other['proxy-groups'] = proxy_groups
            return other

        other = modify_other(other)

        for key in self.ClashKeys:
            if update_keys and key in update_keys:
                value = other[key]
            elif combine_keys and key in combine_keys:
                value = getattr(self, key) | other[key]
            else:
                value = getattr(self, key)

            setattr(self, key, value)
        return self

    def dump_file(self, file: str):
        data = {key: getattr(self, key) for key in self.ClashKeys}
        with open(file, 'w', encoding='utf-8') as f:
            yaml.safe_dump(data, f, allow_unicode=True, default_flow_style=False)
        return data
