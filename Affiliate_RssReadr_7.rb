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

loop do
  create_html = CreateHtml.new()
  create_html.create_body()
  create_html.create_category()
  create_html.create_body_yome()
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

    #create_html.lftp()
  end

  def main()
    print "始まり\n"
    #@affilete_RssReadr_Domain.domain_get()
    ##@affilete_RssReadr_Domain.domain_link()
    #@affilete_RssReadr_link.link_get()
    ##@affilete_RssReadr_link.link_link()
    #@affilete_RssReadr_link.get_rss()
    #@affilete_RssReadr_insert.link_feed_domain()
    print "終わり\n"
  end

  #t0 = Thread.start {
  #loop do
  print "#{Time.now()} Create_html\n"
  @affilete_RssReadr_Create_Rss.get_rdf()
  @affilete_RssReadr_insert.quite_rss()
  create_html()
  #sleep(60*5)
  #end
  #}
=begin
  t1 = Thread.start {
  loop do
  main()
  sleep(rand(10))
end
}

t2 = Thread.start {

}
=end

#t3 = Thread.start {
#loop do
#@affilete_RssReadr_Kyou_no_yome.pic_copy()
#@affilete_RssReadr_insert.link_feed_domain_all()
@affilete_RssReadr_link.get_rss_all()
#sleep(rand(60*30))
end
#}
=begin

t4 = Thread.start {
loop do
#not_rss_url()
sleep(rand(60))
end
}


loop do

create_html = CreateHtml.new()

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
when 1 then
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

sleep(1)
end
=end
