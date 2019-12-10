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
      maker.channel.description = @config.home_description[0]
      maker.channel.link = @config.top_home_page

      @db[:Article].order(:article_date).limit(20).all.each{|report|
        maker.items.new_item do |item|
          item.link = report[:article_link]
          item.title = report[:article_title]
          item.pubDate = report[:article_date]
        end
      }
    end
    File.open(@config.www_html_out_path + "index.rss", "wb:utf-8") do |f|
      f.write(rss)
    end
  end
end

#@affilete_RssReadr_Create_Rss = Create_Rss.new()
#@affilete_RssReadr_Create_Rss.get_rdf()
