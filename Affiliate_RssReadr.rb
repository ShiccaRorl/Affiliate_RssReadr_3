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


create_html = CreateHtml.new()
#create_html.create_body()
#create_html.create_category()
#create_html.create_body_yome()
#create_html.lftp()

@affilete_RssReadr_Domain = Domain.new()
@affilete_RssReadr_link = Link.new()
@affilete_RssReadr_insert = Insert.new()
@affilete_RssReadr_insert.link_feed_domain()

@affilete_RssReadr_Create_Rss = Create_Rss.new()
@affilete_RssReadr_Create_Rss.get_rdf()

@affilete_RssReadr_Kyou_no_yome = Kyou_no_yome.new()



@affilete_RssReadr_Domain.domain_get()
##@affilete_RssReadr_Domain.domain_link()
@affilete_RssReadr_link.link_get()
##@affilete_RssReadr_link.link_link()
#@affilete_RssReadr_insert.link_feed_domain()
#@affilete_RssReadr_link.get_rss_all()

def create_html()
  create_html = CreateHtml.new()
  create_html.create_body()
  create_html.create_category()
  create_html.create_body_yome()
  create_html.lftp()
end

def main()
  #print "始まり\n"
  #@affilete_RssReadr_Domain.domain_get()
  ##@affilete_RssReadr_Domain.domain_link()
  #@affilete_RssReadr_link.link_get()
  ##@affilete_RssReadr_link.link_link()
  #@affilete_RssReadr_link.get_rss()
  #@affilete_RssReadr_insert.link_feed_domain()
  #print "終わり\n"
end

Thread.abort_on_exception = true

t0 = Thread.start {
  logger = Logger.new('./Log/t0.log', 7, 10*1024*1024)
  logger.progname = "html作成(60分間隔)"
  sleep 10
  loop do
    logger.debug("Start")
    @affilete_RssReadr_Create_Rss.get_rdf()
    create_html()
    logger.debug("end")
    sleep(60*60)
  end
}

t1 = Thread.start {
  logger = Logger.new('./Log/t１.log', 7, 10*1024*1024)
  logger.progname = "RSS全取得(60分間隔)"
  sleep 20
  loop do
    logger.debug("Start")
    @affilete_RssReadr_link.get_rss_all()
    logger.debug("end")
    sleep(60*60)
  end
}

t2 = Thread.start {
  logger = Logger.new('./Log/t2.log', 7, 10*1024*1024)
  logger.progname = "RSS_Quite全取得(30分間隔)"
  sleep 30
  loop do
    logger.debug("Start")
    @affilete_RssReadr_insert.quite_rss()
    logger.debug("end")
    sleep(60)
  end
}


t3 = Thread.start {
  logger = Logger.new('./Log/t3.log', 7, 10*1024*1024)
  logger.progname = "画像全取得(60分間隔)"
  sleep 40
  loop do
    logger.debug("Start")
    @affilete_RssReadr_Kyou_no_yome.organize()
    @affilete_RssReadr_Kyou_no_yome.pic_get()
    logger.debug("end")
    sleep(60*60)
  end
}


t4 = Thread.start {
  logger = Logger.new('./Log/t4.log', 7, 10*1024*1024)
  logger.progname = "必要のないリンク削除(60分間隔)"
  sleep 50
  loop do
    logger.debug("Start")
    @affilete_RssReadr_insert.link_feed_domain_all()
    logger.debug("end")
    sleep(60*60)
  end
}



loop do
  print "1 : CreateHtml\n"
  print "2 : Quite_Rss\n"
  print "3 : Domain_All\n"
  print "4 : Up_Load\n"
  print "5 : Get_Rss\n"
  print "6 : Link_Link\n"
  print "7 : Link_Domain\n"
  print "8 : Pic_get\n"
  print "9 : Get_rss_all\n"

  i = gets.chomp.to_i

  case i
  when 0 then
    t0.kill
    t1.kill
    t2.kill
    t3.kill
    t4.kill
    break
  when 1 then
    create_html = CreateHtml.new()
    create_html.create_body()
  when 2 then
    @affilete_RssReadr_insert.quite_rss()
  when 3 then
    @affilete_RssReadr_Domain.domain_get_all()
  when 4 then
    create_html.lftp()
  when 5 then
    @affilete_RssReadr_link.get_rss()
  when 6 then
    @affilete_RssReadr_link.link_link()
  when 7 then
    @affilete_RssReadr_link.link_domain()
  when 8 then
    @affilete_RssReadr_Kyou_no_yome.pic_get()
  when 9 then
    @affilete_RssReadr_link.get_rss_all()
  else
    print "1 : CreateHtml\n"
    print "2 : Quite_Rss\n"
    print "3 : Domain_All\n"
    print "4 : Up_Load\n"
    print "5 : Get_Rss\n"
    print "6 : Link_Link\n"
    print "7 : Link_Domain\n"
    print "8 : Pic_get\n"
    print "9 : Get_rss_all\n"
  end

  sleep(0.5)
end

t0.join
t1.join
t2.join
t3.join
t4.join
