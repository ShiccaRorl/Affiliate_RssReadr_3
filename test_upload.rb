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

@logger = Logger.new('./Log/Test_updata.log', 7, 10*1024*1024)


@logger.progname = "updata"
@logger.debug("Start")
  create_html = CreateHtml.new()

  create_html.lftp()
  @logger.debug("end")
