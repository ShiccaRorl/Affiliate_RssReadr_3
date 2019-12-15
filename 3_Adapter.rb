# -*- encoding: utf-8 -*-

require 'csv'
require 'sequel'
require 'time'
require './3_Config'



class Adapter
  def initialize()
    @config = Config.new()

  end

  # Access処理済み　出力と取り込み

  # MyDB upデータ　出力と取り込み
    # プログラムはここのViewsデータを使用する
    # picはデータベース拡張させてAccessに対応させる

  # QuiteRSS
    # feeds と news そのままコピーする
    # 日付は変換する

  def get_feeds()
    begin
    @config.db[:feeds].all.each{|feed|
        if @config.my_db[:feeds].where(:id=>feed[:id]).first == [] then
          @config.my_db[:feeds].insert(:id=>feed[:id], :text=>feed[:text], :title=>feed[:title], :description=>feed[:description],
            :xmlUrl=>feed[:xmlUrl], :htmlUrl=>feed[:htmlUrl],
            :pubdate=>feed[:pubdate], :lastBuidDate=>feed[:lastBuidDate], :created=>feed[:created], :updated=>feed[:updated])
        else
          @config.my_db[:feeds].update(:id=>feed[:id], :text=>feed[:text], :title=>feed[:title], :description=>feed[:description],
            :xmlUrl=>feed[:xmlUrl], :htmlUrl=>feed[:htmlUrl],
            :pubdate=>feed[:pubdate], :lastBuidDate=>feed[:lastBuidDate], :created=>feed[:created], :updated=>feed[:updated])
        end
    }
    rescue
    end
  end

  def get_news()
    
    loop{
      begin
        newss = @config.db[:news].order(Sequel.desc(:published)).all
          news = newss[rand(:news.size)]
          if @config.my_db[:feeds].where(:id=>news[:id]).first == nil then
            p "insert"
            p news[:id]
            p Time.parse(news[:published].sub("T", " "))
            published = Time.parse(news[:published].sub("T", " "))
            received = Time.parse(news[:received].sub("T", " "))
            @config.my_db[:news].insert(:id=>news[:id], :feedId=>news[:feedId], :title=>news[:title], :published=>published, :received=>received, :link_href=>news[:link_href])
          else
            p "update"
            published = Time.parse(news[:published].sub("T", " "))
            received = Time.parse(news[:received].sub("T", " "))
            @config.my_db[:news].update(:id=>news[:id], :feedId=>news[:feedId], :title=>news[:title], :published=>published, :received=>received, :link_href=>news[:link_href])
          end
        
        rescue
          print "謎エラー\n"
        end
        sleep(1)

    }

  end
end

adapter = Adapter.new()
#adapter.get_feeds()
adapter.get_news()
