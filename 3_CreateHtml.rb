#! snap/bin/ruby
# -*- encoding: utf-8 -*-

require "erb"
require "date"
#require "sqlite3"
require "sequel"


require './3_Config'
#require './3_kyou_no_yome'

class CreateHtml
  attr_accessor :keyword, :css_theme_path, :config, :report
  def initialize()
    @config = Config.new()

    @header          = File.open("./template/header.erb", 'r:utf-8').read
    @footer          = File.open("./template/footer.erb", 'r:utf-8').read
    @body            = File.open("./template/body.erb", 'r:utf-8').read
    @body_yome       = File.open("./template/body_yome.erb", 'r:utf-8').read
    @autoupload_lftp = File.open("./autoupload.lftp", 'r:utf-8').read

    @title = ""

    @page_no = 0

    self.keyword()

    options = {:encoding=>"utf8"}
    @aff_db = Sequel.sqlite("C:/Affiliate_RssReadr_3/Affiliate_Data.SQLite3", options)
    RSSから記事リストを作成する()

  end

    def RSSから記事リストを作成する()
        i = []
        @aff_db[:Article].where(:直接_flag=>0).limit(20).order(Sequel.expr(:use_time).desc).each{|article|
            i << "<a href=\"#{article[:article_link]}\"><img src=\"#{article[:サムネイル_path]}\" alt=\"記事\" width=\"300\" title=\"#{article[:article_title]}\"><\/a><br>#{article[:article_title]}<br>"
        }
        @公開リスト = i

    end


  def keyword()
    @keyword = ""
    if @config.home_category == nil then
      @keyword = "err"
    elsif @config.home_category != nil then
      @config.home_category.each{|key|
        @keyword = "#{@keyword}, " + "#{key[0]}"
      }
    end
    return @keyword.encode!("UTF-8")
  end

  def create_category()
    #何かオプションを指定する場合は下記に追記する
    #options = {:encoding=>"utf8"}

    #@dbに接続
    #@db = Sequel.sqlite("RssData.SQLite3", options)

    @config.home_category.each{|x, y|
      @report = @config.my_db[:V_news].where(Sequel.ilike(:news_title, "%#{ x }%")).limit(100).order(Sequel.desc(:published)).all
      @html = @header + @body + @footer

      #p changelogmemo
      erb = ERB.new(@html)
      @html = erb.result(binding)
      begin
        p @config.www_html_out_path + "#{y}.html"
        #File.write(@config.www_html_out_path + "#{y}.html", @html)
        file = File.open(@config.www_html_out_path + "#{y}.html", "w")
        file.puts @html
        file.close
      
      rescue
        print "カテゴリー　書き込みエラー\n"
      end
    }
  end

  def create_index()
    @report = @config.my_db[:V_news].limit(@config.limit).order(Sequel.desc(:published)).all
    @html = @header + @body + @footer

    erb = ERB.new(@html)

    @html = erb.result(binding)
    File.write(@config.www_html_out_index + "index.html", @html)
    
    File.open("4_アップロード_index.cmd", "w") do |f|
        f.puts("curl -# -T #{@config.www_html_out_index}index.html -u #{@config.ftp_user}:#{@config.ftp_pass} -w %{url_effective}:%{http_code} --ftp-create-dirs -ftp-ssl -ftp-pasv ftp://#{@config.ftp_server}/")
        f.puts("timeout /t 5 > nul")
        f.puts("curl -# -T #{@config.www_html_out_index}index.rss -u #{@config.ftp_user}:#{@config.ftp_pass} -w %{url_effective}:%{http_code} --ftp-create-dirs -ftp-ssl -ftp-pasv ftp://#{@config.ftp_server}/")
        f.puts("timeout /t 5 > nul")
        f.puts("curl -# -T #{@config.www_html_out_index}robots.txt -u #{@config.ftp_user}:#{@config.ftp_pass} -w %{url_effective}:%{http_code} --ftp-create-dirs -ftp-ssl -ftp-pasv ftp://#{@config.ftp_server}/")
        f.puts("timeout /t 5 > nul")
        f.puts("curl -# -T #{@config.www_html_out_index}index_dummy.rss -u #{@config.ftp_user}:#{@config.ftp_pass} -w %{url_effective}:%{http_code} --ftp-create-dirs -ftp-ssl -ftp-pasv ftp://#{@config.ftp_server}/")

      end
  end

  def create_body()
    #何かオプションを指定する場合は下記に追記する
    #options = {:encoding=>"utf8"}

    #@dbに接続
    #@db = Sequel.sqlite("RssData.SQLite3", options)
    #@config = Config.new()

    @page_end = @config.my_db[:V_news].all.size / @config.limit
    #@page_end = 10
    @page_no = 0
    start = @config.limit * @page_no

    @page_no = 0
    (1..@page_end).each{|damy|
      @report = @config.my_db[:V_news].limit(@config.limit).offset(start).order(Sequel.desc(:published)).all
      
      start = @config.limit * @page_no

      # くっつける
      @html = @header + @body + @footer
      #p changelogmemo

      erb = ERB.new(@html)

      @html = erb.result(binding)

      #print "Report 最大 " + @config.db[:news].all.size.to_s + "\n"
      if @page_no == 0 then
        begin
          File.write(@config.www_html_out_path + "index.html", @html)
        rescue
          print "index 書き込みエラー\n"
        end
      else
        begin
          #print "ページ  #{@page_no}  作成\n"
          File.write(@config.www_html_out_path + "index#{@page_no}.html", @html)
        rescue
          print "subpage 書き込みエラー\n"
        end
      end
      @page_no = @page_no + 1
    }

    @page_end = @page_no
  end

  def create_body_yome()
    #何かオプションを指定する場合は下記に追記する
    #options = {:encoding=>"utf8"}

    #@dbに接続
    #@db = Sequel.sqlite("RssData.SQLite3", options)
    #@config = Config.new()

    #@affiliate = @config.my_db[:affiliate].all
    #@affiliate_DMM = @db[:affiliate_DMM].all
    #@affiliate_DMM_Video = @db[:affiliate_DMM_Video].all


    @date = Date.today
    #if @config.my_db[:Article].where(:article_link=>@config.web_pic + "#{@date.to_s}.html").all == [] then
      @page_end = @config.my_db[:V_news].all.size / @config.limit
      @pic = @config.my_db[:pic].order(:使用日).limit(50)

      @pic.each{|pic|
        @config.my_db[:pic].where(:id=>pic[:id]).update(:使用日=>Time.now)
      }
      
      kyou_no_yome = Kyou_no_yome.new()
      kyou_no_yome.pic_get(@pic)

      # くっつける
      @html = @header + @body_yome + @footer
      #p changelogmemo
      # 
      erb = ERB.new(@html)

      @html = erb.result(binding)

      @config.my_db[:Article].insert(:article_title=>"#{@date.to_s} 今日の嫁", :article_link=>@config.web_pic + "#{@date.to_s}.html", :article_date=>@date, :use_time=>Time.now)
      
      begin
        File.write(@config.web_pic + "#{@date.to_s}.html", @html)
      rescue
        print "書き込みエラー\n"
      end
    
    #else
      #print "今日は何回するき？\n"
    #end
  end



  def lftp()
    erb = ERB.new(@autoupload_lftp)
    lftp = erb.result(binding)

    begin
      File.write("./autoupload.lftp", lftp)
    rescue
      p "書き込みエラー"
    end

    command = "lftp -f ./autoupload.lftp"
    begin
      system(command)
    rescue
      print "アップロード失敗\n"
    end

  end

  def html_up()
    File.open("4_アップロード.cmd", "w") do |f|
      Dir.glob("#{@config.www_html_out_path}**/*.css").each{|file|
        #f.puts("curl -# -T #{file} -u #{@config.ftp_user}:#{@config.ftp_pass} -w %{url_effective}:%{http_code} --ftp-create-dirs -ftp-ssl -ftp-pasv ftp://#{@config.ftp_server}/")
      }
      
      Dir.glob("#{@config.www_html_out_path}*/*.html").each{|file|
        f.puts("curl -# -T #{file} -u #{@config.ftp_user}:#{@config.ftp_pass} -w %{url_effective}:%{http_code} --ftp-create-dirs -ftp-ssl -ftp-pasv ftp://#{@config.ftp_server}/article/")
        f.puts("timeout /t 5 > nul")
        #system("curl -# -T #{file} -u #{@config.ftp_user}:#{@config.ftp_pass} -w %{url_effective}:%{http_code} --ftp-create-dirs -ftp-ssl -ftp-pasv ftp://#{@config.ftp_server}/")
        #system("timeout /t 5 > nul")
        #sleep(1)
    }
    end
    #system("4_アップロード.cmd")
  end
end


create_html = CreateHtml.new()

if ARGV[0] == "category" then
  create_html.create_category()
elsif ARGV[0] == "body" then
  create_html.create_body()
elsif ARGV[0] == "yome" then
  create_html.create_body_yome()
elsif ARGV[0] == "yome_up"

elsif ARGV[0] == "up_all"
  create_html.lftp()
elsif ARGV[0] == "html_up"
  create_html.html_up()
elsif ARGV[0] == "index"
  create_html.create_index()
else

end