# -*- coding: utf-8 -*-
# @Author: longfengpili
# @Date:   2024-12-13 11:18:53
# @Last Modified by:   longfengpili
# @Last Modified time: 2024-12-17 14:20:18
# @github: https://github.com/longfengpili

import requests

import logging
brequestlogger = logging.getLogger(__name__)


class BRequests:

    def __init__(self):
        self.response = None

    def _get(self, url: str, params: dict = None, headers: dict = None, **kwargs):
        res = requests.get(url, params=params, headers=headers)
        return res

    def _post(self, url: str, params: dict = None, headers: dict = None, data: dict = None):
        res = requests.post(url, params=params, headers=headers, data=data)
        return res

    def request_api(self, method: str, url: str, params: dict = None, headers: dict = None, 
                    data: dict = None, res_type: str = None, retries: int = 3):
        attempt = 0
        while attempt < retries:
            mrequest = self._post if method == 'post' else self._get
            response = mrequest(url, params, headers=headers, data=data)
            if response.status_code in (200, 204):
                self.response = response
                # print(response.request.headers)
                break

            attempt += 1
            brequestlogger.error(f"[{method}] {url}, Attempt {attempt}, status_code: {response.status_code}")

        if res_type == 'json':
            result = response.json()
        elif res_type == 'content':
            result = response.content
        else:
            result = response.text
        return result
