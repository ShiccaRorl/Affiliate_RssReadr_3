# -*- encoding: utf-8 -*-

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import datetime
from sqlalchemy import desc

class Config():
    def __ini__(self):
        self.db_dir = "C:/Affiliate_RssReadr_3/Affiliate_Data.SQLite3"
        self.記事_dir = "./記事/"
        self.肩書 = "４０歳童貞大魔法使いによる、今晩の嫁さがし。"


class MGS記事():
    def __ini__(self, id):
        self.config = Config()
        self.id = id
        self.作品名 = ""
        self.女優 = ""
        self.aff = "C7EL5ZIM2LIYL36AOUMDGYKNTJ"
        self.基本url = "https://www.mgstage.com/product/product_detail/" + self.id
        self.url = self.基本url + "/?aff=" + self.aff



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
        engine = create_engine(self.config.db_dir, echo=False)
        Session = sessionmaker(bind=engine)
        self.session1 = Session()


    def session_close(self):
        # セッション・クローズ
        # DB処理が不要になったタイミングやスクリプトの最後で実行

        self.session1.close()


if __name__ == '__main__':
    config = Config()
    MGS記事 = MGS記事()
