# -*- encoding: utf-8 -*-

require 'sequel'

require 'rss'
#require 'feedzirra'
#require 'nokogiri'
require 'rexml/document'

require './Config'
require './Root'



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



@affilete_RssReadr_link = Link.new()
@affilete_RssReadr_link.get_rss()