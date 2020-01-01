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
    for row2 in session2.query(QuiteRSS).all():
        #print(row2.id, row2.feedId, row2.title, row2.published, row2.received, row2.link_href)
        #print(row2.published)
        ###
        try:
            newss = session1.query(News.id).all()
            for news in newss:

    
                print(row2.title)
                time1 = datetime.datetime.strptime(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                time2 = datetime.datetime.strptime(row2.received.replace("T", " "), '%Y-%m-%d %H:%M:%S')
        
                ed_user = News(row.id==row2.id, row.feedId==row2.feedId, row.title==row2.title, row.published==time1, row.received==time2, row.link_href==row2.link_href)
                session1.add(ed_user)

                session1.commit()
                print ("データ取得")
        except:
                print ("不思議なエラー")

        
    # セッション・クローズ
    # DB処理が不要になったタイミングやスクリプトの最後で実行
    session1.close()
    session2.close()


def get_all_sin():
    for row2 in session2.query(QuiteRSS).all():
        #print(row2.id, row2.feedId, row2.title, row2.published, row2.received, row2.link_href)
        #print(row2.published)
        time.sleep(1)
        try:
            newss = session1.query(News.id).order_by(desc(News.received)).all()
            for news in newss:
                print(row2.title)

                time1 = datetime.datetime.strptime(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                time2 = datetime.datetime.strptime(row2.received.replace("T", " "), '%Y-%m-%d %H:%M:%S')

        
                ed_user = News(row.id==row2.id, row.feedId==row2.feedId, row.title==row2.title, row.published==time1, row.received==time2, row.link_href==row2.link_href)
                session1.add(ed_user)

                session1.commit()
                print ("データ取得")
        except:
                print ("不思議なエラー")

        
    # セッション・クローズ
    # DB処理が不要になったタイミングやスクリプトの最後で実行
    session1.close()
    session2.close()

def get_all_now(day):

    for row2 in session2.query(QuiteRSS).order_by(desc(News.received)).limit(day):
        #print(row2.id, row2.feedId, row2.title, row2.published, row2.received, row2.link_href)
        #print(row2.published)
        time.sleep(1)
        i = 0
        if i <= 20:
            try:
                newss = session1.query(News.id).order_by(desc(News.received)).all()
                for news in newss:

    
                    print(row2.title)
                    print(row2.published.replace("T", " "))
                    print(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                    time1 = datetime.datetime.strptime(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                    time2 = datetime.datetime.strptime(row2.received.replace("T", " "), '%Y-%m-%d %H:%M:%S')

        
                    ed_user = News(row.id==row2.id, row.feedId==row2.feedId, row.title==row2.title, row.published==time1, row.received==time2, row.link_href==row2.link_href)
                    session1.add(ed_user)

                    session1.commit()

                    print ("データ取得")
            except:
                    print ("不思議なエラー")
                    # 不思議エラーが20回続くと終わる。
                    print ("不思議エラー " + str(i) + " 回目")
                    i = i + 1
                    if i >= 20:
                        break

        
    # セッション・クローズ
    # DB処理が不要になったタイミングやスクリプトの最後で実行
    session1.close()
    session2.close()


#get_all_old()
#get_all_sin()
#get_all_now(100)



