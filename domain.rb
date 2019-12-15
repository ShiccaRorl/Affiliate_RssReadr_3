# -*- encoding: utf-8 -*-


class Domain < Root
  def initialize()
    self.create_root()
  end

  def domain_get()
    print "========================domain_get\n"
    #何かオプションを指定する場合は下記に追記する
    #options = {:encoding=>"utf8"}

    #@dbに接続
    #@db = Sequel.sqlite("RssData.SQLite3", options)

    # ダウンロード
    #domains = @db[:Site].where(:Update_time =< "2019-03-05").select(:domain).all
    domain = @db[:Site].select(:domain, :Fixed, :stop).order(:Update_time).first
    execution_domain_get(domain)
  end



  def domain_get_all()
    print "========================domain_all\n"
    @db[:Site].select(:domain, :Fixed, :stop).order(:Update_time).all.each{|domain|
      execution_domain_get(domain)
    }
  end

  def execution_domain_get(domain)
    domain = domain
    #domains = @db[:Site].where(:Update_time =< "2019-03-05").select(:domain).all

    #print domain[:domain] + "\n"
    #print "ダウンロード\n"
    begin
      system('python ./download.py ' + domain[:domain] + " ./temp/domain_all")
    rescue
      print "ダウンロード失敗\n"
      return
    end
    data = ""
    File.open("./temp/domain_all", "rb:utf-8") do |f|
      data = f.read()
    end
    title = data.scan(/<title>(.*?)<\/title>|<TITLE>(.*?)<\/TITLE>/m)
    name = $1
    rsss = self.get_rss_url(data)
    rsss.each{|rss|

      flag = 0
      @db[:NotRssUrl].select(:not_rss_url).all.each{|not_rss_url|
        if not_rss_url == rss then
          flag = 1
        end
      }

      if rss != nil and rss.size <= 100 and flag == 0 and domain[:Fixed] == false and domain[:stop] == false then

        if @db[:Site].where(:domain=>domain[:domain], :name=>nil).select(:name).first == nil then
          print "サイト名ゲット : " + domain[:domain] + "\n"
          @db[:Site].where(:domain=>domain[:domain]).update(:name=>name, :Update_time=>Time.now())
        end
        if @db[:Site].where(:domain=>domain[:domain], :rss_url=>nil).select(:rss_url).first == nil then
          print "RSSゲット : " + domain[:domain] + "\n"
          @db[:Site].where(:domain=>domain[:domain]).update(:rss_url=>rss, :Update_time=>Time.now())
        end
      else
        #print "ドメイン更新出来ない\n"
      end
    }


    #失敗回数１０を超えたときの処理
    @db[:Site].where(:end=>true).select(:rss_url).all.each{|rss_url|
      if @db[:NotRssUrl].select(:not_rss_url).all == [] then
        #無効Urlを登録する
        @db[:NotRssUrl].insert(:not_rss_url=>rss_url)

        #サイトのデータをリセットする
        @db[:Site].where(:rss_url=>rss_url[:rss_url]).update(:err=>0, :end=>false)
      end


    }

    @db[:Site].where(:domain=>domain[:domain]).update(:Update_time=>Time.now())
  end

  #リンクをダウンロードして、Siteにドメインを登録する。
  def domain_link()
    print "========================domain_link\n"

    #Linkからドメインを登録する。
    #links = @db[:Link].where(Sequel.like(:link, '%http%')).select(:link).all
    link = @db[:Link].where(:end=>false).select(:link).order(:Update_time).first

    link2 = self.get_rss_url(link[:link])

    link2.each{|url|
      #リンクがSiteに登録されていないのと、httpを含まないモノはSiteに登録される。リンクはアップデートと終了の印が保存される
      if @db[:Site].where(:rss_url=>url).select(:domain).all == [] then
        print "ドメイン追加 : " + url + "\n"
        @db[:Site].insert(:rss_url=>url, :Create_time=>Time.now())
        @db[:Link].where(:link=>url).update(:Update_time=>Time.now(), :end=>true)
      end

      #リンクが既にSiteに登録されている。ので、アップデートと終了の印をつける。
      if @db[:Site].where(:rss_url=>url).select(:domain).all != [] then
        @db[:Link].where(:link=>url).update(:Update_time=>Time.now(), :end=>true)
      end
    }

    @db[:Link].where(:link=>url).update(:Update_time=>Time.now(), :end=>true)
  end
end
