# -*- coding: utf-8 -*-

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from A_News import News
from A_QuiteRSS import QuiteRSS
import datetime
from sqlalchemy import desc

import time
import threading
from concurrent.futures import ThreadPoolExecutor
 
engine2 = create_engine('sqlite:///C:/Users/ban/AppData/Local/QuiteRss/QuiteRss/feeds.db', echo=False)
Session2 = sessionmaker(bind=engine2)
session2 = Session2()


engine = create_engine('sqlite:///RssData.SQLite3', echo=False)
Session = sessionmaker(bind=engine)
session1 = Session()


def get_all_old():
    i = 0
    s = 0
    for row2 in session2.query(QuiteRSS).order_by(News.id).all(): # 全データ指定

        try:
                print(row2.title)
                time1 = datetime.datetime.strptime(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                time2 = datetime.datetime.strptime(row2.received.replace("T", " "), '%Y-%m-%d %H:%M:%S')
        
                quite_rss = News()
                quite_rss.id = row2.id
                quite_rss.feedId = row2.feedId
                quite_rss.title = row2.title
                quite_rss.published = time1
                quite_rss.received = time2
                quite_rss.link_href = row2.link_href
                session1.add(quite_rss)

                session1.commit()
                print ("データ取得")
                print(str(row2.id))
                i = i + 1
        except:
                print ("データがあります。")
                print(str(row2.id))
                s = s + 1
                
    # セッション・クローズ
    # DB処理が不要になったタイミングやスクリプトの最後で実行
    session1.close()
    session2.close()

    print("取得データ" + str(i) + "個目")
    print("取得済データ" + str(s) + "個目")



def get_all_sin():
    i = 0
    s = 0
    for row2 in session2.query(QuiteRSS).order_by(desc(News.id)).all(): # 全データ指定
        try:
                print(row2.title)
                time1 = datetime.datetime.strptime(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                time2 = datetime.datetime.strptime(row2.received.replace("T", " "), '%Y-%m-%d %H:%M:%S')
        
                quite_rss = News()
                quite_rss.id = row2.id
                quite_rss.feedId = row2.feedId
                quite_rss.title = row2.title
                quite_rss.published = time1
                quite_rss.received = time2
                quite_rss.link_href = row2.link_href
                session1.add(quite_rss)

                session1.commit()
                print ("データ取得")
                print(str(row2.id))
                i = i + 1
        except:
                print ("データがあります。")
                print(str(row2.id))
                s = s + 1

        
    # セッション・クローズ
    # DB処理が不要になったタイミングやスクリプトの最後で実行
    session1.close()
    session2.close()

    print("取得データ" + str(i) + "個目")
    print("取得済データ" + str(s) + "個目")



def get_all_now(day):
    i = 0
    s = 0
    for row2 in session2.query(QuiteRSS).order_by(desc(News.id)).limit(day): # 全データ指定
        t = 0
        if t <= 20:
            try:
                print(row2.title)
                time1 = datetime.datetime.strptime(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                time2 = datetime.datetime.strptime(row2.received.replace("T", " "), '%Y-%m-%d %H:%M:%S')
        
                quite_rss = News()
                quite_rss.id = row2.id
                quite_rss.feedId = row2.feedId
                quite_rss.title = row2.title
                quite_rss.published = time1
                quite_rss.received = time2
                quite_rss.link_href = row2.link_href
                session1.add(quite_rss)

                session1.commit()
                print ("データ取得")
                print(str(row2.id))
                i = i + 1
            except:
                print ("データがあります。")
                print(str(row2.id))
                s = s + 1
                t = t + 1
        
    # セッション・クローズ
    # DB処理が不要になったタイミングやスクリプトの最後で実行
    session1.close()
    session2.close()

    print("取得データ" + str(i) + "個目")
    print("取得済データ" + str(s) + "個目")



if __name__ == '__main__':
    #get_all_old()
    #get_all_sin()
    #get_all_now(100)

    import sys
    import subprocess

    args = sys.argv
    if args[1] == []:
        print ("オプション old 古い順番からデータをコピーします。")
        print ("オプション sin 新しい順番からデータをコピーします。")
        print ("オプション now 直近のデータをコピーします。")
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
        print ("オプション old 古い順番からデータをコピーします。")
        print ("オプション sin 新しい順番からデータをコピーします。")
        print ("オプション now 直近のデータをコピーします。")



