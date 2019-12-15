# -*- coding:utf-8 -*-

class Insert < Root
  def initialize()
    self.create_root()
  end
  def quite_rss()
    print "========================quite_rss\n"

    options = {:encoding=>"utf8"}

    #DBに接続
    quite_rss_db = Sequel.sqlite(@config.quite_rss_path, options)


    quite_rss_db[:feeds].exclude(:title => nil).all.each{|feed|
      sleep 1
      if @db[:Site].where(:domain => feed[:htmlUrl]).all == [] then
        print "ドメイン追加 : " + feed[:htmlUrl] + "\n"
        @db[:Site].insert(:domain=>feed[:htmlUrl], :name=>feed[:title], :rss_url=>feed[:xmlUrl], :Create_time=>Time.now())
      end
    }
    quite_rss_db[:news].order(Sequel.expr(:published).desc).all.each{|feed|
	print feed
sleep 1
      if @db[:Report].where(:url=>feed[:link_href]).all ==[] then
        print "Report追加 Quite : " + feed[:title] + "\n"
        @db[:Report].insert(:url=>feed[:link_href], :name=>feed[:title], :pubDate=>feed[:published], :Create_time=>Time.now)
      end
    }

  end



  def link_feed_domain()
    rss = @db[:Link].where(:end=>true).order(:Update_time).first
    execution_link_feed(rss)
  end

  def link_feed_domain_all()
    @db[:Link].where(:end=>true).order(:Update_time).all.each{|rss|
      sleep 1
      execution_link_feed(rss)
    }
  end

  def execution_link_feed(rss)
    rss = rss
    links = get_rss_url(rss[:link])
    i = ""
    if links == [] and rss[:end] == true then
      print "削除！！ : #{rss}\n"
      @db[:Link].where(:link=>rss[:link]).delete
    elsif links != [] then
      links.each{|link|
        if @db[:Site].where(:rss_url=>link).all == [] then
          print "追加 : #{link}\n"
          @db[:Site].insert(:rss_url=>link, :Create_time=>Time.now())
        end
        i = link
      }
    end
    if @db[:Link].where(:link=>i).all != [] then
      @db[:Link].where(:link=>i).update(:Update_time=>Time.now())
    end
  end


  #Feedのエラー処理
  def not_rss_url()
    #何かオプションを指定する場合は下記に追記する
    #options = {:encoding=>"utf8"}

    #@dbに接続
    #@db = Sequel.sqlite("RssData.SQLite3", options)

    #うまく取れないサイトを予測入力する。
    @db[:Site].where(:rss_url=>nil).select(:domain).all.each{|domain|
      @db[:Site].where(:domain=>domain[:domain]).update(:rss_url=>domain[:domain] + "feed", :Update_time=>Time.now())
    }



  end

  def err_initialize()
    #何かオプションを指定する場合は下記に追記する
    #options = {:encoding=>"utf8"}

    #@dbに接続
    #@db = Sequel.sqlite("RssData.SQLite3", options)

    @db[:Site].select(:name).all.each{|tt|
      @db[:Site].update(:err=>0, :end=>false)
    }
  end
end
