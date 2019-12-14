# -*- encoding: utf-8 -*-

#require 'csv'
#require 'sequel'
#require 'time'
#require './3_Config'



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
    @config.db[:feeds].all.each{|feed|
        if @config.my_db[:feeds].where(:id=>feed[:id]).all == [] then
          @config.my_db[:feeds].insert(:id=>feed[:id], :text=>feed[:text], :title=>feed[:title], :description=>feed[:description],
            :xmlUrl=>feed[:xmlUrl], :htmlUrl=>feed[:htmlUrl],
            :pubdate=>feed[:pubdate], :lastBuidDate=>feed[:lastBuidDate], :created=>feed[:created], :updated=>feed[:updated])
        else
          @config.my_db[:feeds].update(:id=>feed[:id], :text=>feed[:text], :title=>feed[:title], :description=>feed[:description],
            :xmlUrl=>feed[:xmlUrl], :htmlUrl=>feed[:htmlUrl],
            :pubdate=>feed[:pubdate], :lastBuidDate=>feed[:lastBuidDate], :created=>feed[:created], :updated=>feed[:updated])
        end
    }
  end

  def get_news()
    @config.db[:news].order(Sequel.desc(:published)).all.each{|news|
      begin
      if @config.my_db[:feeds].where(:id=>news[:id]).all == [] then
        #p Time.parse(news[:published].sub("T", " "))
        published = Time.parse(news[:published].sub("T", " "))
        received = Time.parse(news[:received].sub("T", " "))
        @config.my_db[:news].insert(:id=>news[:id], :feedId=>news[:feedId], :title=>news[:title], :published=>published, :received=>received, :link_href=>news[:link_href])
    
      else
        published = Time.parse(news[:published].sub("T", " "))
        received = Time.parse(news[:received].sub("T", " "))
        @config.my_db[:news].update(:id=>news[:id], :feedId=>news[:feedId], :title=>news[:title], :published=>published, :received=>received, :link_href=>news[:link_href])
      end
    rescue
      p "謎エラー"
    end
    }
  end
end

adapter = Adapter.new()
#adapter.get_feeds()
adapter.get_news()
