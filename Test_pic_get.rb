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

@logger = Logger.new('./Log/Test_pic_get.log', 7, 10*1024*1024)


@logger.progname = "pic_get"
@logger.debug("Start")

kyou_no_yome = Kyou_no_yome.new()
kyou_no_yome.organize()
kyou_no_yome.pic_get
@logger.debug("end")
