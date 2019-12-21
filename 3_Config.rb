# -*- encoding: utf-8 -*-

#require "fileutils"
#require 'sequel'

class Config
    # 取得した画像を処理する設定
    attr_accessor :gazou_path, :scrapBook, :file_size, :source_scrapBook, :c_source_scrapBook, :c_gazou_path, :c_scrapBook
    # ホームページの設定
    attr_accessor :home_title, :top_home_page, :home_category, :limit, :home_description, :css_theme_path, :www_html_out_path, :wd
    # アフェリエイトの設定
    attr_accessor :affiliate, :article_size, :affiliate_size, :affiliate_DMM_size, :affiliate_DMM_Video_top_size, :affiliate_DMM_Video_size
    attr_accessor :affiliate_DMM, :affiliate_DMM_Video_Top, :affiliate_DMM_Video
    # 画像の設定
    attr_accessor :pic_path, :web_pic, :pic_size_min, :pic_size_max
    # データベースの設定
    attr_accessor :db, :my_db
    # FTPの設定
    attr_accessor :ftp_server, :ftp_port, :ftp_user, :ftp_pass

    def initialize()
        # 
        @c_source_scrapBook = "C:\\Users\\ban\\Downloads\\WebScrapBook\\"
        @c_gazou_path = "e:\\画像ファイル\\"
        @c_scrapBook  = "e:\\ScrapBook\\"

        @source_scrapBook = "C:/Users/ban/Downloads/WebScrapBook/"
        @gazou_path = "e:/画像ファイル/"
        @scrapBook  = "e:/ScrapBook/"
        @file_size = 40000

        # データベース探し
        db_file_path1 = "./feeds.db"
        db_file_path2 = "C:/Users/ban/AppData/Local/QuiteRss/QuiteRss/feeds.db"
        db_file_path3 = "C:/Users/ban/AppData/Local/QuiteRss/QuiteRss/feeds.db"
        if File.exist?(db_file_path1) then
            @db_file_path = db_file_path1 # ルート
        elsif File.exist?(db_file_path2) then
            @db_file_path = db_file_path2 # Windows
        elsif File.exist?(db_file_path3) then
            @db_file_path = db_file_path3 # Linux
        else
            @db_file_path = db_file_path1 # ルート
        end
        print @db_file_path + "  データソースを使います。\n"

    #何かオプションを指定する場合は下記に追記する
    options = {:encoding=>"utf8"}
    #DBに接続
    @db = Sequel.sqlite(@db_file_path, options)

    # こちらのデータベース
    options = {:encoding=>"utf8"}
    @my_db = Sequel.sqlite("./RssData.SQLite3", options)

    # ホームページタイトル
    @home_title = "今日の嫁"

    # ホームページトップ
    @top_home_page = "http://kyounoyome.x.fc2.com/"

    @wd = ["日", "月", "火", "水", "木", "金", "土"]

    # ホームページカテゴリー
    @home_category = [["フェラ","fella"],["３Ｐ","3P"],["AV女優","AV"],["おしっこ","osikko"],["おっぱい","Boobs"],
                     ["ごっくん","gokkun"],["二次","2jigen"],["三次","3jigen"],["ちんこ","tinko"],["ふたなり","hutanari"],["お掃除フェラ","fella2"],["ハーレム","harem"],["くぱぁ","kupa"],
                     ["ぶっかけ","bukkake"],["アナル","anal"],["おまんこ","Pussy"],["まんこ","Pussy1"],["ま〇こ","Pussy2"],["アヘ顔","ahegao"],["イラマチオ","Gagging"],["オナニー","solo"],
                     ["クスコ","kusuko"],["コンドーム","Condom"],["ザーメン","za-men"],["水着","Swimsuit"],["スペルマ","Sperm"],["セックス","sex"],
                     ["ハーレム","Group"],["パイパン","Hairless"],["パンチラ","Upskirt"],["ビッチ","Bitch"],["ブルマ","buruma"],["ペニス","Cock"],
                     ["ポルチオ","porutio"],["ロリ","loli"],["中出し","creampie"],["処女","Virgin"],["口内射精","kounaisyasei"],["同人誌","doujinnsi"],
                     ["孕ませ","haramase"],["巨乳","melon"],["潮吹き","female_ejaculation"],["精子","cream"],["触手","tentacle"],["顔射","Cum_Shot"]]

    #一枚のHTMLに表示する記事
    @limit = 300

    # ホームページのdescription
    @home_description = ["アンテナだけではなく、今日のおかずも並べていきたいです。",
                         "今日の嫁はぶっかけよー",
                         "今日の嫁はごっくんよー。",
                         "今日の嫁はビッチよー。",
                         "今日の嫁は女子高生！",
                         "今日の嫁はぶっかけを避けます。",
                         "今日の嫁は安全日"
                       ]
    @home_description = @home_description[rand(@home_description.size)]
    @home_description.encode!("UTF-8")
    
    # CSS Path
    @css_theme_path = "./theme/be_r5/be_r5.css"

    @affiliate = @my_db[:affiliate].all
    @affiliate_DMM = @my_db[:affiliate_DMM].where(:stop=>false).all
    @affiliate_DMM_Video_Top = @my_db[:affiliate_DMM_Video].where(:stop=>false).all
    @affiliate_DMM_Video = @my_db[:affiliate_DMM_Video].where(:stop=>false).all

    # 一度に表示する日数
    @article_size = 10

    # 一度に表示するアフェリエイトの数
    @affiliate_size = 30

    # 一度に表示するアフェリエイトの数 DMM
    @affiliate_DMM_size = 30

    # 一度に表示するアフェリエイトの数 DMM
    @affiliate_DMM_Video_top_size = 30

    # 一度に表示するアフェリエイトの数 DMM
    @affiliate_DMM_Video_size = 5

    # htmlの作成先
    @www_html_out_path = "e:/www/"

    # FTPの設定
    @ftp_server = "kyounoyome.x.fc2.com"
    @ftp_port = "21"
    @ftp_user = "kyounoyome"
    @ftp_pass = "X?GF1ytvn@"

    #@quite_rss_path = "./../../../../保存ファイル/プログラム/QuiteRSS/feeds.db"

    #画像の保存場所
    @pic_path = "e:/ScrapBook/"
    #web用の保存場所
    @web_pic = @www_html_out_path + "Pic/"

    @pic_size_min = 50000
    @pic_size_max = 1024000
    end
end