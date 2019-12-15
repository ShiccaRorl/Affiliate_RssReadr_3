# -*- encoding: utf-8 -*-

require 'sequel'
#require 'pg'
#require 'mysql2'

options = {:encoding=>"utf8"}

#DBに接続
#@db = Sequel.sqlite("RssData.SQLite3", options)

#DB = Sequel.connect("mysql://ban:aniki1119@localhost/Affiliate_RssReadr", encoding: 'utf8')

#DB = Sequel.connect(:adapter => 'postgresql', :database=>"Affiliate_RssReadr", :user=>"ban", :password=>"aniki1119")
#DB = Sequel.connect("postgresql://ban:aniki1119@localhost/Affiliate_RssReadr")

mySql = Sequel.mysql('Affiliate_RssReadr', :host=>'localhost ', :user=>'root', :password=>'aniki1119', :port=>'3306', encoding: 'utf8')

print mySql
