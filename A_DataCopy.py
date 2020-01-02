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

class DataCopy():
    def __init__(self):
        self.i = 0


    def get_all_old(self):
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



    def get_all_sin(self):
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



    def get_all_now(self,day):
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

    def null_kill(self):
        for row2 in session2.query(News.published==None).order_by(desc(News.id)).all: # 全データ指定
            print(row2)
            print (row2.title)    








if __name__ == '__main__':
    t = DataCopy()
    #t.get_all_old()
    t.get_all_sin()
    t.get_all_now(100)
    #null_kill()