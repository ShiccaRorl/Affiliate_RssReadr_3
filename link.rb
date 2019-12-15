# -*- coding:utf-8 -*-

class Link < Root
  def initialize()
self.create_root()
  end

  #リンクの登録
  def link_get()
    print "========================link_get\n"
    #何かオプションを指定する場合は下記に追記する
    #options = {:encoding=>"utf8"}

    #@dbに接続
    #@db = Sequel.sqlite("RssData.SQLite3", options)

    # ダウンロード
    #domains = @db[:Site].where(:Update_time =< "2019-03-05").select(:domain).all
    domain = @db[:Site].select(:domain).order(:Update_time).first

    #print domain[:domain] + "\n"
    #print "ダウンロード\n"
    begin
      system('python ./download.py ' + domain[:domain] + " ./temp/link")
    rescue
      print "ダウンロード失敗\n"
      return
    end
    data = ""
    File.open("./temp/link", "rb:utf-8") do |f|
      data = f.read()
    end
    links = data.scan(/<a href=.*?<\/a>/)
    links.each{|link|

      if @db[:Link].where(:link=>link).select(:link).all == [] and link != nil and link.size <=100 then
        print "リンク追加 : " + link + "\n"

        if @db[:Site].where(:domain=>link).select(:id).all == [] then
          @db[:Site].insert(:domain=>link, :Create_time=>Time.now())
        end
        id = @db[:Site].where(:domain=>link).select(:id).first
        @db[:Link].insert(:link=>link, :Site_id=>id[:id], :Create_time=>Time.now(), :end=>false)
      end


    }
    @db[:Site].where(:domain=>link).update(:Update_time=>Time.now())

  end



  def link_link()
    print "========================link_link\n"

    # ダウンロード
    #domains = @db[:Site].where(:Update_time =< "2019-03-05").select(:domain).all
    domain = @db[:Link].select(:link).order(:Update_time).first

    #print domain[:domain] + "\n"
    #print "ダウンロード\n"
    begin
      system('python ./download.py ' + domain[:link] + " ./temp/link_link")
    rescue
      print "ダウンロード失敗\n"
      return
    end

    data = ""
    File.open("./temp/link_link", "rb:utf-8") do |f|
      data = f.read()
    end
    links = data.scan(/<a href=.*?<\/a>/)
    links.each{|link2|
      #links.scan(/.:?"(.:?)".*?/)
      link = $1
      if @db[:Link].where(:link=>link).select(:link).all == [] and link != nil then
        print "リンクのリンク追加 : " + link + "\n"

        #リンクのリンクがSiteに登録されていない場合、登録する。
        #if @db[:Site].where(:domain=>link).select(:id).all == [] then
        #print "リンクのリンクをSiteに登録\n"
        #@db[:Site].insert(:domain=>link, :Create_time=>Time.now)
        #end

        #id = @db[:Site].where(:domain=>link).select(:id).first
        @db[:Link].insert(:link=>link, :Create_time=>Time.now(), :end=>false)
      end

    }
    if link != nil then
      @db[:Link].where(:link=>link).update(:Update_time=>Time.now())
    end
  end
  #RSSをダウンロードしてReportに保存する
  def get_rss()
    print "========================get_rss\n"


    # ダウンロード。httpを含むRSSのURLをダウンロードする。
    rss_url = @db[:Site].where(Sequel.ilike(:rss_url, '%http%')).select(:rss_url, :id, :ok).order(:Rss_Update_time).first

    self.execution_get_rss(rss_url)

  end


  def get_rss_all()
    print "========================get_rss_all\n"
    @db[:Site].where(Sequel.ilike(:rss_url, '%http%')).select(:rss_url, :id, :ok).order(:Rss_Update_time).all.each{|rss_url|
sleep 1
      self.execution_get_rss(rss_url)
    }
  end

  def execution_get_rss(rss_url)
    rss_url=rss_url


    sleep(1)
    begin
      system('python ./download_nama.py ' + rss_url[:rss_url] + " ./temp/get_rss_all")
    rescue
      print "ダウンロード失敗\n"
      return
    end
    data = ""
    File.open("./temp/get_rss_all", "rb:utf-8") do |f|
      data = f.read()
    end

    begin
      rss = RSS::Parser.parse(data)
      #p "============="
      #print rss.channel.title
      if @db[:Site].where(:name=>nil, :rss_url=>rss_url[:rss_url]).first then
        print "サイト名ゲット : " + rss.channel.title + "\n"
        @db[:Site].where(:rss_url=>rss_url[:rss_url]).update(:name=>rss.channel.title)
      end
      rss.channel.items.each{|item|
        #print item.title + "\n"
        #print item.link + "\n"
        #print item.pubDate.strftime( "%Y/%m/%d" ) + "\n"

        if @db[:Report].where(:url=>item.link).all == [] and item != nil then
          print "Report追加 : " + item.title + " : " + item.link + "\n"
          @db[:Report].insert(:name=>item.title, :url=>item.link, :site_id=>rss_url[:id], :pubDate=>item.pubDate, :Rss_Update_time=>Time.now())
          @db[:Site].where(:rss_url=>rss_url[:rss_url]).update(:Rss_Update_time=>Time.now())
          print "パース成功\n"
          @db[:Site].where(:rss_url=>rss_url[:rss_url]).update(:ok=>rss_url[:ok]+1)
        end
      }

    rescue

      begin
        items = data.scan(/<item.*?<\/item>|<ITEM.*?<\/ITEM>/)

        if items != [] then
          items.each{|item|
            item.scan(/<link>(.*?)<\/link>|<LINK>(.*?)<\/LINK>/)
            @link = $1
            item.scan(/<title>(.*?)<\/title>|<TITLE>(.*?)<TITLE>/)
            @title = $1
            #item.scan(/<dc:date>(.*?)<\/dc:date>/)
            #date = $1
          }
        end

        if @db[:Report].where(:url=>@link).all == [] and @link != nil then
          print "Report追加 無理やり : " + @title + " : " + @link + "\n"
          @db[:Report].insert(:name=>@title, :url=>@link, :site_id=>rss_url[:id], :Rss_Update_time=>Time.now())
          @db[:Site].where(:rss_url=>rss_url[:rss_url]).update(:Rss_Update_time=>Time.now())
          print "無理やりパース成功\n"
          @db[:Site].where(:rss_url=>rss_url[:rss_url]).update(:Rss_Update_time=>Time.now(), :ok=>rss_url[:ok]+1)
        end
      rescue
        if rss_url != nil then
          dame = @db[:Site].where(:rss_url=>rss_url[:rss_url]).select(:err).first
          @db[:Site].where(:rss_url=>rss_url[:rss_url]).update(:Rss_Update_time=>Time.now(), :err=>dame[:err]+1)

          dame = @db[:Site].where(:rss_url=>rss_url[:rss_url]).select(:err).first
          if dame[:err] >= 20 then
            @db[:Site].where(:rss_url=>rss_url[:rss_url]).update(:end=>true)
          end
        end
        print "パース失敗\n"
      end
    end
    @db[:Site].where(:rss_url=>rss_url[:rss_url]).update(:Rss_Update_time=>Time.now())

  end
end
