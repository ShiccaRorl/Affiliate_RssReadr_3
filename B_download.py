# -*- coding:utf-8 -*-

import requests

import re
import sys
from io import StringIO


args = sys.argv

url = args[1]

resp = requests.get(url)

s_new = ''.join(resp.text.splitlines())

with open('./lib/TwitterKitigaiZima/sure/' + str(sure_no.group()) + ".sure", 'w', encoding="utf-8") as f:
    f.write(s_new)
    f.close()

