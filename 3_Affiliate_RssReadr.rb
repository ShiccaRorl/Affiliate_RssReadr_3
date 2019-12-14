# -*- encoding: utf-8 -*-

require "erb"
require "date"
require 'sequel'
require "csv"

require './3_Config'
require './3_kyou_no_yome'

# 動作を考えた

# エロ画像を探してくる。保存する。
# inport.rb で掃除。同一画像などを削除する。画像一覧の csv を取り出して、Accessに取り込む。
# 
# Accessで画像処理 主キーはHDのURL
# Accessで加工データを csv を取り出して Affiliate_RssReadr に取り込む。
# 既存のデータはアップデート
# 新規の画像はインポート

# RSSは QuiteRSS からデータをコピーしてくる。日付（文字列）を加工してコピーしてくる。
# 今日の嫁は出来るだけする。出来なければ、ランダムで画像群を作る。
# サムネイムも出来るだけやる










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
      @report = @config.db[:news].where(Sequel.ilike(:title, "%#{ x }%")).limit(100).order(Sequel.desc(:published)).all
      @html = @header + @body + @footer

      #p changelogmemo
      erb = ERB.new(@html)
      @html = erb.result(binding)
      begin
        File.write(@config.www_html_out_path + "#{y}.html", @html)
      rescue
        print "カテゴリー　書き込みエラー\n"
      end
    }
  end

  def create_body()
    #何かオプションを指定する場合は下記に追記する
    #options = {:encoding=>"utf8"}

    #@dbに接続
    #@db = Sequel.sqlite("RssData.SQLite3", options)
    #@config = Config.new()

    @page_end = @config.db[:news].all.size / @config.limit

    @page_no = 0
    start = @config.limit * @page_no

    @page_no = 0
    (1..@page_end).each{|damy|
      @report = @config.db[:news].limit(@config.limit).offset(start).order(Sequel.desc(:published)).all

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
    if @config.my_db[:Article].where(:url=>@config.web_pic + "#{@date.to_s}.html").first == [] then
      @page_end = @config.db[:news].all.size / @config.limit
      @pic = @config.my_db[:pic].all

      # くっつける
      @html = @header + @body_yome + @footer
      #p changelogmemo

      erb = ERB.new(@html)

      @html = erb.result(binding)

      @config.my_db[:Article].insert(:article_title=>"#{@date.to_s} 今日の嫁", :article_link=>@config.web_pic + "#{@date.to_s}.html", :article_date=>@date, :use_time=>Time.now)
      
      begin
        File.write(@config.web_pic + "#{@date.to_s}.html", @html)
      rescue
        print "書き込みエラー\n"
      end
    
    else
      print "今日は何回するき？\n"
    end
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
end


create_html = CreateHtml.new()
create_html.create_category()
create_html.create_body()
#create_html.create_body_yome()
create_html.lftp()
