# -*- encoding: utf-8 -*-

from time import sleep

# マルチスレッド

import time
import threading
from concurrent.futures import ThreadPoolExecutor
import subprocess

from A_DataCopy import DataCopy

class RssReadr:
    def part1(self):
        timer = 60*60 # 一時間に一度HTMLを作成うｐする
        command = '4_html作成.cmd'
        subprocess.run(command)
        sleep(timer)

    def part2(self):
        timer = 60*15 # 15分に一度最近のを取り出す
        command = '4_最新.cmd'
        subprocess.run(command)
        sleep(timer)

    def part3(self):
        timer = 60*60*24*20 # 20日に一度最近から取り出す
        sleep(timer)
        command = '4_新しい→古い.cmd'
        subprocess.run(command)
        sleep(timer)

    def part4(self):
        timer = 60*60*24*20 # 20日に一度古い方から取り出す
        sleep(timer)
        command = '4_古い→新しい.cmd'
        subprocess.run(command)
        sleep(timer)

    def part5(self):
        timer = 60*60*24 # 1日に一度カテゴリーの更新
        command = '4_カテゴリー作成.cmd'
        subprocess.run(command)
        sleep(timer)

    def part6(self):
        timer = 60*60*24*10 # 10日に一度重複記事を削除
        sleep(timer)
        command = '4_古い→新しい.cmd'
        subprocess.run(command)
        sleep(timer)

    def bkup(self):
        timer = 60*60*24*5 # 5日に一度バックアップ
        command = '4_バックアップ.cmd'
        subprocess.run(command)
        sleep(timer)



    def main(self):
        tpool = ThreadPoolExecutor(max_workers=3)
        while True:
            print("Threads: {}".format(len(tpool._threads)))  # スレッド数を表示
            tpool.submit(self.part1())
            tpool.submit(self.part2())
            tpool.submit(self.part3())
            #tpool.submit(self.part4())
            tpool.submit(self.part5())
            tpool.submit(self.part6())
            tpool.submit(self.bkup())
        print("main thread exit.")


import sys

rss_readr = RssReadr()
rss_readr.main()

"""
args = sys.argv
if args[1] == None:
    print ("オプション old 古い順番からデータをコピーします。")
    print ("オプション sin 新しい順番からデータをコピーします。")
    print ("オプション now 直近のデータをコピーします。")
    print ("オプション html htmlを作ります。")
elif str(args[1]) == "old":
    rss_readr.get_all_old()
elif args[1] == "sin":
    rss_readr.get_all_sin()
elif args[1] == "now":
    rss_readr.get_all_now(100)
elif args[1] == "html":
    command = 'C:/Affiliate_RssReadr_3/Affiliate_RssReadr_3/3_CreateHtml.cmd > ./part1.txt'
    subprocess.run(command)
else:
    print ("オプション old 古い順番からデータをコピーします。")
    print ("オプション sin 新しい順番からデータをコピーします。")
    print ("オプション now 直近のデータをコピーします。")
    print ("オプション html htmlを作ります。")
    rss_readr.main()
"""
