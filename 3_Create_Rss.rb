# -*- encoding: utf-8 -*-

require 'rss'
require "date"

require 'sequel'
require './3_Config'

class Create_Rss
  def initialize()
    @config = Config.new()
  end

  def get_rdf()
    rss = RSS::Maker.make("1.0") do |maker|
      maker.channel.about = @config.top_home_page + "index.rss"
      maker.channel.title = @config.home_title
      maker.channel.description = @config.home_description
      maker.channel.link = @config.top_home_page

      #@b_config.aff_db[:Article].order(:use_time).limit(20).each{|report|
      @config.aff_db[:Article].order(:use_time).each{|report|
        maker.items.new_item do |item|
          item.link = report[:article_link]
          item.title = report[:article_title]
          item.pubDate = report[:use_time]
        end
      }
    end
    File.open(@config.www_html_out_index + "index.rss", "w:utf-8") do |f|
      f.write(rss)
    end
    
    # グーグル用
    rss = RSS::Maker.make("1.0") do |maker|
      maker.channel.about = @config.top_home_page + "index.rss"
      maker.channel.title = @config.home_title
      maker.channel.description = @config.home_description
      maker.channel.link = @config.top_home_page

      #@b_config.aff_db[:Article].order(:use_time).limit(20).each{|report|
      @config.aff_db[:Article].where(:直接_flag=>0).order(:use_time).each{|report|
        maker.items.new_item do |item|
          item.link = report[:article_link]
          item.title = report[:article_title]
          item.pubDate = report[:use_time]
        end
      }
    end
    File.open(@config.www_html_out_index + "index_dummy.rss", "w:utf-8") do |f|
      f.write(rss)
    end

    # robots.txt
    File.open(@config.www_html_out_index + "robots.txt", "w:utf-8") do |f|
      f.write("User-agent:*\n")
      f.write("Sitemap:" + @config.top_home_page + "index_dummy.rss")

    end


  end

  def RSSをアップロードする()
    File.open("RSSをアップロードする.cmd", "w:utf-8") do |f|

      # Google への サイトマップ送信URL:
      url = (@config.top_home_page + "index_dummy.rss").gsub(/([^a-zA-Z0-9\-\._~!\$'\(\)\*+,;:\@\/\?])/) { "%#{$1.unpack('H*')[0].scan(/../).join('%').upcase }" }
      p url
      f.puts("curl https://www.google.com/ping?sitemap=" + url)
      system("curl https://www.google.com/ping?sitemap=" + url)

      # Bing への サイトマップ送信URL:
      f.puts("curl https://www.bing.com/ping?sitemap=" + @config.top_home_page + "index_dummy.rss")
      system("curl https://www.bing.com/ping?sitemap=" + @config.top_home_page + "index_dummy.rss")

    end
    
  end
end

@affilete_RssReadr_Create_Rss = Create_Rss.new()
@affilete_RssReadr_Create_Rss.get_rdf()
@affilete_RssReadr_Create_Rss.RSSをアップロードする()