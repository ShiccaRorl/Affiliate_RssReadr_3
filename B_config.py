# -*- encoding: utf-8 -*-

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import datetime
from sqlalchemy import desc

from B_Affiliate_MGS_Video import Affiliate_MGS_Video

from datetime import datetime
import os

import requests

from io import StringIO
from time import sleep
import re

import subprocess

class Config():
    def __init__(self):
        self.db_dir = "C:/Affiliate_RssReadr_3/Affiliate_Data.SQLite3"
        self.サイト名 = "MGS"
        self.記事_dir = "E:/www/" + self.サイト名 + "/"
        self.肩書 = "４０歳童貞大魔法使いによる、今晩の嫁さがし。"
        

        

        # データベースのIDから記事DIRがあるか確認する
        # 無ければ作る。
        # テンプレートをコピーする。
        # テンプレートは各部品がある。
        # データベースのデータを作る。
        # 記事のデーターをダウンロードする。
        # 画像・テキスト・タイトル・サンプル動画
        # データベースないの更新日時とテンプレートが一致しないものは、データ処理する。
        # RSSをfeedを更新する。
        # 
        # 

    def session_open(self):
        engine = create_engine("sqlite:///" + self.db_dir, echo=False)
        Session = sessionmaker(bind=engine)
        self.session = Session()


    def session_close(self):
        # セッション・クローズ
        # DB処理が不要になったタイミングやスクリプトの最後で実行

        self.session.close()




class MGS記事():
    def __init__(self, id):
        self.config = Config()
        self.id = id
        self.作品名 = ""
        self.女優 = ""
        self.aff = "C7EL5ZIM2LIYL36AOUMDGYKNTJ"
        self.基本url = "https://www.mgstage.com/product/product_detail/" + self.id + "/"
        self.url = self.基本url + "?aff=" + self.aff
        self.記事元dir = self.config.記事_dir + self.id + "/"
        self.サンプル動画 = ""
        self.photo_s = []


        #print(self.基本url)
        self.データベース補完()
        self.ディレクトリーファイルの初期化()
        #self.ページをダウンロードする()
        
        self.ファイルを配置する()
        #self.解析する()
        self.rubyを実行する()


    def データベース補完(self):
        self.config.session_open()
        print(self.id)
        try:
            if self.config.session.query(Affiliate_MGS_Video).filter(Affiliate_MGS_Video.aff==None).first():
                記事 = self.config.session.query(Affiliate_MGS_Video).filter(Affiliate_MGS_Video.id==self.id).first()
                記事.aff = self.aff
                print(記事)
                self.config.session.commit()
                print("aff : データ更新")
            else:
                print ("aff データあり")
        except:
            print ("aff err============")
        self.config.session_close()
        # ===================================謎のエラーが起きているので「self.基本url」を使ってください。↓
        self.config.session_open()
        print(self.基本url)
        try:
            if self.config.session.query(Affiliate_MGS_Video).filter(Affiliate_MGS_Video.基本url==None).first():
                記事 = self.config.session.query(Affiliate_MGS_Video).filter(Affiliate_MGS_Video.id==self.id).first()
                記事.基本url = self.基本url
                print(記事)
                self.config.session.commit()
                print("基本url : データ更新")
            else:
                print ("基本url データあり")
        except:
            print ("基本url err============")
        self.config.session_close()
        # ===================================謎↑
        self.config.session_open()
        try:
            if self.config.session.query(Affiliate_MGS_Video).filter(Affiliate_MGS_Video.url==None).first():
                記事 = self.config.session.query(Affiliate_MGS_Video).filter(Affiliate_MGS_Video.id==self.id).first()
                記事.url = self.url
                print(記事)
                self.config.session.commit()
                print("url : データ更新")
            else:
                print ("url データあり")
        except:
            print ("url err============")
        self.config.session_close()
        # ===================================
        self.config.session_open()
        try:
            if self.config.session.query(Affiliate_MGS_Video).filter(Affiliate_MGS_Video.作成日==None).first():
                記事 = self.config.session.query(Affiliate_MGS_Video).filter(Affiliate_MGS_Video.id==self.id).first()
                記事.作成日 = datetime.now()
                print(記事)
                self.config.session.commit()
                print("作成日 : データ更新")
            else:
                print ("作成日 データあり")
        except:
            print ("作成日 err============")
        self.config.session_close()

    def ディレクトリーファイルの初期化(self):
        print("作成ディレクトリー :" + self.記事元dir)
        if os.path.exists(self.記事元dir):
            print(self.id + "存在します")
        else:
            print(self.id + "存在しません")
            try:
                os.mkdir(self.記事元dir)
            except:
                print("ディレクトリーが作れません。==========")

    def ページをダウンロードする(self):
        print(self.記事元dir + "/seed.dat")
        if os.path.exists(self.記事元dir + "/seed.dat"):
                print("seed.dat  存在する。")
        else:
            print("seed.dat ファイルは存在しない。")
            headers = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36",
                        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",}
            resp = requests.get(self.基本url, headers=headers)  # ダウンロード
            print(resp.status_code)
            print(resp.headers)
            print(resp.text)
            s_new = ''.join(resp.text.splitlines())
            with open(self.記事元dir + "seed.dat", 'w', encoding="utf-8") as f:
                f.write(s_new)
                f.close()
            sleep(10)

    def ファイルを配置する(self):
        if os.path.exists(self.記事元dir + "seed.txt"):
            print("seed.txt  存在する。")
        else:
            with open(self.記事元dir + "seed.txt", 'w', encoding="utf-8") as f:
                f.write("")
                f.close()

        if os.path.exists(self.記事元dir + "サンプル動画.txt"):
                print("サンプル動画.txt  存在する。")
        else:
            with open(self.記事元dir + "サンプル動画.txt", 'w', encoding="utf-8") as f:
                f.write("")
                f.close()

        if os.path.exists(self.記事元dir + "記事.txt"):
                print("記事.txt  存在する。")
        else:
            with open(self.記事元dir + "記事.txt", 'w', encoding="utf-8") as f:
                f.write("")
                f.close()

    def 解析する(self):
        f = open(self.記事元dir + "seed.txt", "r", encoding="utf-8")
        s = f.read()
        f.close()
        seed = ''.join(s.splitlines())
        #p = re.compile(r'(<title>).*?')
        #m = p.match(seed)
        match = re.search(r'<title>(.*?)</title>', seed)
        print(match.group(0))
        #print(m)

    def rubyを実行する(self):
        subprocess.run("ruby B_Config.rb")

class MGS記事s():
    def __init__(self):
        self.config = Config()

        self.config.session_open()
        self.mgs_ids = self.config.session.query(Affiliate_MGS_Video.id).filter(Affiliate_MGS_Video.固定==0).all()
        self.記事s = []
        #t = 0
        for i in self.mgs_ids:
            print (i)
            #if t == 0:
            #    t = 1
            #else:
            self.記事s.append(MGS記事(list(i)[0]))

        #del self.記事s[0] #削除出来たらいいのだけど。
        #self.記事s.remove(None) #出来ない。
        self.config.session_close()



if __name__ == '__main__':
    config = Config()
    
    MGS記事s = MGS記事s()
    #MGS記事 = MGS記事("ABP-933")

