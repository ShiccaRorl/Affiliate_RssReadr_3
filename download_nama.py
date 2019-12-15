# -*- coding:utf-8 -*-

import requests

import re
import sys
from io import StringIO


args = sys.argv

url = args[1]
dl_data = args[2]

#sure_no = re.search(r'\d\d\d\d\d\d\d\d\d\d', url)
#print (sure_no.group())
#url = "http://matsuri.5ch.net/test/read.cgi/denpa/1523734497/"

if len(args) == 3:
    proxies = {
       'http': 'http://localhost:8118',
       'https': 'http://localhost:8118'
    }
elif len(args) == 4:
    proxies = {'http': '%s' % args[3],
               'https': '%s' % args[3]}

headers={"referer": "https://www.google.co.jp/",
                              "User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; rv:11.0) like Gecko",
                              "Accept-Language": "ja,en-US;q=0.7,en;q=0.3"}



resp = requests.get(url, headers=headers)

s_new = ''.join(resp.text.splitlines())

with open(dl_data, 'w', encoding="utf-8") as f:
    f.write(s_new)
    f.close()


#f = open('sample.txt', 'r', encoding="utf-8")
#data = f.read()
#f.close()

#print(data)
#s_new = ''.join(data.splitlines())

#print(s_new)

#m = re.split(r'<div class="post"(.*?)<div class="post"', s_new)
#title = re.search(r'<title>(.*?)<\/title>', s_new)
#sure_no = re.search(r'\d\d\d\d\d\d\d\d\d\d', url)

#del m[0]

#print(sure_no)
#print(title)

#print(m[0])
#id = re.search(r'<span class="number">(.*?)<\/span>', m[0])
#id = id.replace('<span class="number">', "")
#id = id.replace('<\/span>', "")
#print(id)

#name = re.search(r'<span class="name"><b>(.*?)</b></span>', m[0])
#name = name.replace('<span class="name"><b>', "")
#name = name.replace('</b></span>', "")
#print(name)

#daytime = re.search(r'<span class="date">(>*?)</span>', m[0])
#daytime = daytime.replace('<span class="date">', "")
#daytime = daytime.replace('</span>', "")
#print(daytime)

#uid = re.search(r'<span class="uid">(.*?)</span>', m[0])
#uid = uid.replace('<span class="uid">', "")
#uid = uid.replace('</span>', "")
#print(uid)

#message = re.search(r'<div class="message"><span class="escaped">(.*)</span></div>', m[0])
#message = message.replace('<div class="message"><span class="escaped">', "")
#message = message.replace('</span></div>', "")
#print(message)


#print(m[1])
