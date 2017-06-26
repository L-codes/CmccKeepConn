#!/usr/bin/env python
#-*-coding:UTF-8-*-
# Date 2017-06-26

try:
    import requests
except:
    raise SystemExit('[Error] Please install "requests": pip install requests')
import time
import re
import random
import signal

__program__ = 'cmccKeepConn'
__version__ = '1.0.1'
__author__ = 'L'
__github__ = 'https://github.com/L-codes/cmccKeepConn'

def interrupt_handler(signalnum, frame):
    raise SystemExit("\r    \n[Interrupt] I guess you're off duty")


class CMCC_FREE:
    def __init__(self, url):
        print('[+] auto keep connect ...')
        self.get_info(url)


    def get_info(self, debug_url):
        wlanacname, wlanuserip = self._get_url_info(debug_url)
        phone = random.randint(13500000000, 13599999999)
        url_head = 'http://221.176.66.85:81/wlan-portal-web/'
        user_agent = 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)'

        self.url = url_head + 'service/portalAccountService.loginByPortal.rest?t=1459479089251'
        self.headers = {
            'Referer': url_head + 'portal?wlanacname=' + wlanacname + '&wlanuserip=' + wlanuserip + '&wlanacssid=CMCC-FREE&spe=ggmb',
            'User-Agent': user_agent,
            'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json, text/javascript, */*; q=0.01',
            'Accept-Encoding': 'gzip, deflate',
            'Pragma': 'no-cache',
            'DNT': '1'
        }

        self.data = {
            'paramMap.USER': phone,
            'paramMap.PWD':  ' ' * 6,
            'paramMap.wlanacname': wlanacname,
            'paramMap.wlanuserip': wlanuserip,
            'paramMap.actiontype': 'LOGIN',
            'paramMap.wlanacssid': 'CMCC-FREE',
            'paramMap.forceflag': 1,
            'paramMap.useragent': user_agent,
            'paramMap.spe': 'ggmb'
        } 

        print('[+] IP: {}, Phone: {}\n'.format(wlanuserip, phone))


    def keep_conn(self, interval_min=50):
        self.counter = 0
        while True:
            self._post_request()
            print(self._keep_status())
            time.sleep(interval_min * 60)


    def _keep_status(self):
        self.counter += 1
        t = time.strftime("%H:%M:%S", time.localtime())
        top3 = {1: '1st', 2: '2nd', 3: '3rd'}
        times = top3[self.counter] if self.counter in top3 else str(self.counter) + 'th'
        return '[+] {} - The {} certification was successful'.format(t, times)


    def _post_request(self):
        times = 2
        while times > 0:
           try:
                r = requests.post(url=self.url, data=self.data, headers=self.headers, timeout=3)
                times -= 1
            except:
                pass


    def _get_url_info(self, url):
        while True:
            try:
                r = requests.get(url=url, allow_redirects=True, timeout=3)
            except requests.exceptions.ProxyError:
                raise SystemExit('[Error] Can not connect to the network, please check the proxy settings')
            except Exception:
                pass
            
            wlanacname = re.search(r'wlanacname=(.*?)&', r.url)
            wlanuserip = re.search(r'wlanuserip=(.*?)&', r.url)
            if wlanacname and wlanuserip:
                wlanacname = wlanacname.group(1)
                wlanuserip = wlanuserip.group(1)
                break
            time.sleep(3)
        return wlanacname, wlanuserip


if __name__ == '__main__':
    signal.signal(signal.SIGINT, interrupt_handler)
    banner = '''
  ____                    _  __                ____                  
 / ___|_ __ ___   ___ ___| |/ /___  ___ _ __  / ___|___  _ __  _ __  
| |   | '_ ` _ \ / __/ __| ' // _ \/ _ \ '_ \| |   / _ \| '_ \| '_ \ 
| |___| | | | | | (_| (__| . \  __/  __/ |_) | |__| (_) | | | | | | |
 \____|_| |_| |_|\___\___|_|\_\___|\___| .__/ \____\___/|_| |_|_| |_|
                                       |_|                           
               [ Author {}       Version {} ]

[ Github ] {}
'''.format(__author__, __version__, __github__)
    print(banner)
    cmcc = CMCC_FREE('http://github.com/L-codes')
    cmcc.keep_conn()

