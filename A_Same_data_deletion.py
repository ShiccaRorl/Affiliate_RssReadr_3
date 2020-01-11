# -*- coding: utf-8 -*-

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from A_News import News
from A_QuiteRSS import QuiteRSS
import datetime
from sqlalchemy import desc

from time import sleep

class SameDataDeletion():
    def session_open(self):
        #engine2 = create_engine('sqlite:///home/ban/.local/share/QuiteRss/QuiteRss/feeds.db', echo=False)
        engine2 = create_engine('sqlite:///C:/Users/ban/AppData/Local/QuiteRss/QuiteRss/feeds.db', echo=False)
        Session2 = sessionmaker(bind=engine2)
        self.session2 = Session2()


    def session_close(self):
        # セッション・クローズ
        # DB処理が不要になったタイミングやスクリプトの最後で実行

        self.session2.close()

    def timeInput(self):
        i = 0
        for i in range(500000):
            self.session_open() # .filter(News.id==i, News.published_datetime==None)
            for row2 in self.session2.query(News).filter(News.published_datetime==None).order_by(News.id).limit(100): # 全データ指定
                try:
                    print(row2.title)
                    # 「T」「Z」が邪魔である
                    z = row2.published.replace("Z", "") # Z削除
                    print ("z : " + z)
                    t = z.replace("T", " ") # T削除
                    print ("t : " + t)
                    time1 = datetime.datetime.strptime(t, '%Y-%m-%d %H:%M:%S') # 文字列を時間に変換
                    print(str(time1))
                    #article = self.session2.query(News).filter(row2.id==i, row2.published_datetime==None).first()

                    row2.published_datetime = time1

                    self.session2.commit()
                    print ("データ追加")
                    print(str(row2.id))
                    #i = i + 1
                except:
                    print ("データがあります。")
                    print(str(row2.id))
                    break
            
                sleep(1)
            self.session_close()
            print("取得データ" + str(i) + "個目")

    def delete(self):
        print ("")


if __name__ == '__main__':
    sameData = SameDataDeletion()

    import sys

    args = sys.argv
    if args[1] == None:
        print ("オプション time 日付データを追加します。")
        print ("オプション del 同じ記事を削除します。新しいのが残るようにします。")
    elif str(args[1]) == "time":
        sameData.timeInput()
    elif args[1] == "del":
        sameData.delete()

    else:
        print ("オプション time 日付データを追加します。")
        print ("オプション del 同じ記事を削除します。新しいのが残るようにします。")