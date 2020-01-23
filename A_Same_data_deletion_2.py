
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
        engine = create_engine('sqlite:///C:/Affiliate_RssReadr_3/RssData.SQLite3', echo=False)
        Session = sessionmaker(bind=engine)
        self.session1 = Session()


    def session_close(self):
        # セッション・クローズ
        # DB処理が不要になったタイミングやスクリプトの最後で実行

        self.session1.close()

    def delete(self):
        self.session_open()
        for row2 in self.session1.query(News).order_by(desc(News.id)).all(): # 全データ指定
            if len(self.session1.query(News).filter(News.title == row2.title).all()) == 1:
                print (row2.title)
                print ("オンリーデータ")
                # 一個しかないので何もしない
            else:
                print(len(self.session1.query(News).filter(News.title == row2.title).all()))
                t = self.session1.query(News).filter(News.title == row2.title).order_by(desc(News.id)).first()
                print (t.id)
                print (t.title)
                try:
                    self.session1.query(News).filter(News.id == t.id).delete()
                    self.session1.commit()
                except:
                    print("データ使用中")
        self.session_close()

    def delete2(self):
        self.session_open()
        for row2 in self.session1.query(News).order_by(desc(News.id)).all(): # 全データ指定
            if len(self.session1.query(News).filter(News.title == row2.title).all()) == 1:
                print (row2.title)
                print ("オンリーデータ")
                # 一個しかないので何もしない
            else:
                print(len(self.session1.query(News).filter(News.title == row2.title).all())) # 個数表示
                s = self.session1.query(News).filter(News.title == row2.title).all() # 対象データ全部取得
                t = self.session1.query(News).filter(News.title == row2.title).order_by(News.id).first() # 新しいデータ一個取得
                print ("全データ数       : " + str(len(s)))
                s.remove(t)
                print ("削除対象データ数 : " + str(len(s)))
                print (s[0].title)
                for d in s:
                    try:
                        self.session1.query(News).filter(News.id == d.id).delete()
                        self.session1.commit()
                    except:
                        print("データ使用中")
        self.session_close()

if __name__ == '__main__':
    sameData = SameDataDeletion()
    sameData.delete2()

    import sys


    args = sys.argv
    if args[1] == None:
        print ("")
    elif str(args[1]) == "first":
        sameData.delete()
    elif args[1] == "all":
        sameData.delete2()

    else:
        print ("オプション first 一個ずつ削除")
        print ("オプション all   一気に削除")