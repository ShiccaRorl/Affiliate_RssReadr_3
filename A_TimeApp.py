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

def dateTimeApp():
    for row2 in session2.query(QuiteRSS).order_by(desc(News.id)):
        i = 0
        if i <= 20:
            try:
                print(row2.title)
                print(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                time1 = datetime.datetime.strptime(row2.published.replace("T", " "), '%Y-%m-%d %H:%M:%S')
                print(str(row2.id))
                news = session2.query(News).filter(News.id == int(row2.id))
                print(str(news))
                news.published_datetime = time1
                session2.commit()

                print ("データ取得")
            except:
                print ("不思議なエラー")
                # 不思議エラーが20回続くと終わる。
                print ("不思議エラー " + str(i) + " 回目")
                i = i + 1
                #if i >= 20:
                   #break

        
    # セッション・クローズ
    # DB処理が不要になったタイミングやスクリプトの最後で実行
    session2.close()





dateTimeApp()
