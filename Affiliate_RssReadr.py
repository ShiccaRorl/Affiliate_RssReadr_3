# -*- encoding: utf-8 -*-

from time import sleep

# マルチスレッド

import time
import threading
from concurrent.futures import ThreadPoolExecutor
import subprocess

from A_DataCopy import *



def part1():
    timer = 60*60 # 一時間に一度HTMLを作成うｐする
    command = 'C:/Affiliate_RssReadr_3/Affiliate_RssReadr_3/3_CreateHtml.cmd > ./part1.txt'
    subprocess.run(command)
    sleep(timer)

def part2():
    timer = 60*15 # 15分に一度最近のを取り出す

    get_all_now(100)
    sleep(timer)

def part3():
    timer = 60*60*24*20 # 20日に一度最近から取り出す

    get_all_sin()
    sleep(timer)

def part4():
    timer = 60*60*24*20 # 20日に一度古い方から取り出す

    get_all_old()
    sleep(timer)

def main():
    tpool = ThreadPoolExecutor(max_workers=3)
    while True:
        print("Threads: {}".format(len(tpool._threads)))  # スレッド数を表示
        tpool.submit(part1())
        tpool.submit(part2())
        tpool.submit(part3())
        tpool.submit(part4())
    print("main thread exit.")


import sys


args = sys.argv
if args[1] == []:
    print ("オプション old 古い順番からデータをコピーします。")
    print ("オプション sin 新しい順番からデータをコピーします。")
    print ("オプション now 直近のデータをコピーします。")
    print ("オプション html htmlを作ります。")
elif args[1] == "old":
    get_all_old()
elif args[1] == "sin":
    get_all_sin()
elif args[1] == "now":
    get_all_now(100)
elif args[1] == "html":
    command = 'C:/Affiliate_RssReadr_3/Affiliate_RssReadr_3/3_CreateHtml.cmd > ./part1.txt'
    subprocess.run(command)
else:
    main()

