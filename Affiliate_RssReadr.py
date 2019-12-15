# -*- encoding: utf-8 -*-

import time
import concurrent.futures


def func1():
    while True:
        print('1 : CreateHtml')
        str = input('>> ')
        if str == "1":
            print("==========CreateHtml")
            subprocess.Popen("ruby" "CreateHtml.rb")
            subprocess.Popen("ruby" "Create_Rss.rb")
        elif str == "end":
            break
        else:
            print('1 : CreateHtml')
        time.sleep(1)


def func2():
    while True:
        print("==========CreateHtml")
        subprocess.Popen("ruby" "CreateHtml.rb")
        subprocess.Popen("ruby" "Create_Rss.rb")
        print("==========kyou_no_yome")
        subprocess.Popen("ruby" "kyou_no_yome.rb")
        time.sleep(60*60)

def func3():
    while True:



        time.sleep(60*60)


if __name__ == "__main__":
    executor = concurrent.futures.ProcessPoolExecutor(max_workers=3)
    executor.submit(func1)
    executor.submit(func2)
    executor.submit(func3)
