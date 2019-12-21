from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from A_News import News
from A_QuiteRSS import QuiteRSS
import datetime
from sqlalchemy import desc

import time
import threading
from concurrent.futures import ThreadPoolExecutor
 
from A_Time import Timer

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

    
                #print("===")
                print(row2.published.replace("T", " "))
                print(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                time1 = datetime.datetime.strptime(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                time2 = datetime.datetime.strptime(row2.received.replace("T", " "), '%Y-%m-%d %H:%M:%S')

        
                ed_user = News(row.id==row2.id, row.feedId==row2.feedId, row.title==row2.title, row.published==time1, row.received==time2, row.link_href==row2.link_href)
                session1.add(ed_user)

                session1.commit()
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

    
                #print("===")
                print(row2.published.replace("T", " "))
                print(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                time1 = datetime.datetime.strptime(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                time2 = datetime.datetime.strptime(row2.received.replace("T", " "), '%Y-%m-%d %H:%M:%S')

        
                ed_user = News(row.id==row2.id, row.feedId==row2.feedId, row.title==row2.title, row.published==time1, row.received==time2, row.link_href==row2.link_href)
                session1.add(ed_user)

                session1.commit()
        except:
                print ("不思議なエラー")

        
    # セッション・クローズ
    # DB処理が不要になったタイミングやスクリプトの最後で実行
    session1.close()
    session2.close()

def get_all_now(day):

    for row2 in session2.query(QuiteRSS).limit(day):
        #print(row2.id, row2.feedId, row2.title, row2.published, row2.received, row2.link_href)
        #print(row2.published)
        time.sleep(1)
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
        except:
                print ("不思議なエラー")

        
    # セッション・クローズ
    # DB処理が不要になったタイミングやスクリプトの最後で実行
    session1.close()
    session2.close()


#get_all_old()
#get_all_sin()
#get_all_now(100)


# マルチスレッド

import time
import threading
from concurrent.futures import ThreadPoolExecutor


def spam():
    for i in range(3):
        time.sleep(1)
        print("thread: {}, value: {}".format(threading.get_ident(), i))


def main():
    tpool = ThreadPoolExecutor(max_workers=3)
    for i in range(6):
        print("Threads: {}".format(len(tpool._threads)))  # スレッド数を表示
        tpool.submit(get_all_old())
        tpool.submit(get_all_sin())
        tpool.submit(get_all_now(300))
    print("main thread exit.")


main()