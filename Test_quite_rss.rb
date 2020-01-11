# -*- encoding: utf-8 -*-

require 'sequel'

require 'rss'
#require 'feedzirra'
#require 'nokogiri'
require 'rexml/document'

require './Config'
require './Root'
require 'logger'


require './insert'
#require './output'
require './domain'
require './link'
require './CreateHtml'
require './Create_Rss'
require './Kyou_no_yome'

@config = Config.new()
options = {:encoding=>"utf8"}

#DBに接続
@db = Sequel.sqlite("RssData.SQLite3", options)
#@affilete_RssReadr_Kyou_no_yome = Kyou_no_yome.new()
#@affilete_RssReadr_Kyou_no_yome.pic_get()
=begin
kyou_no_yome = Kyou_no_yome.new()
p @db[:Pic].all
p @db[:Pic].all.size

@db[:Pic].all.each{|file|
  p "======================"
  p @config.web_pic
  p file[:url2]
  p file[:url2].sub!(@config.web_pic, "./")
  @db[:Pic].where(:url=>file[:url]).update(:url3=>file[:url2].sub!(@config.web_pic, "./"))
}
=end
@logger = Logger.new('./Log/Test_quite_rss.log', 7, 10*1024*1024)


@logger.progname = "quite_rss"
@logger.debug("Start")
a = Insert.new
a.quite_rss()
@logger.debug("end")
