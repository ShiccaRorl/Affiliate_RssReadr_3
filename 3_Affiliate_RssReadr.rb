# -*- encoding: utf-8 -*-

require "erb"
require "date"
require 'sequel'
require "csv"
require 'time'
require 'parallel'

require './3_Config'
require './3_Adapter'
require './3_Create_Rss'
require './3_CreateHtml'
require './3_inport'
require './3_Timer'


# 動作を考えた

# エロ画像を探してくる。保存する。
# inport.rb で掃除。同一画像などを削除する。画像一覧の csv を取り出して、Accessに取り込む。
# 
# Accessで画像処理 主キーはHDのURL
# Accessで加工データを csv を取り出して Affiliate_RssReadr に取り込む。
# 既存のデータはアップデート
# 新規の画像はインポート

# RSSは QuiteRSS からデータをコピーしてくる。日付（文字列）を加工してコピーしてくる。
# 今日の嫁は出来るだけする。出来なければ、ランダムで画像群を作る。
# サムネイムも出来るだけやる


#adapter = Adapter.new()
#adapter.get_feeds()
#adapter.get_news()




def create_html()
  timer = Timer(60*60)
  while timer.get_time == true do
    create_html = CreateHtml.new()
    create_html.create_category()
    create_html.create_body()
    create_html.create_body_yome()
    create_html.lftp()

    create_rss = Create_Rss.new()
    create_rss.get_rdf()
    sleep(5)
  end
  timer.reset()
end

