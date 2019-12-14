# -*- encoding: utf-8 -*-

require "date"
require "fileutils"

require 'sequel'
require './3_Config'


class Kyou_no_yome
  def initialize()
    @config = Config.new()

  end

def organize()
  Dir.glob("#{@config.pic_path}**/*").each{|file|
     if file.index("*.ico") or file.index("*.html") or file.index("*.htm") or file.index("*.css") or file.index("*.eot") or file.index("*.svg") or file.index("*.ttf") or file.index("*.woff") or file.index("*.woff2") then
       File.delete(file)
     end
  }

end


  def pic_get()
    date = Date.today
    cunt = 0
    i = 0
    Dir.glob("#{@config.pic_path}**/*.jpeg\0#{@config.pic_path}**/*.jpg\0#{@config.pic_path}**/*.png\0#{@config.pic_path}**/*.gif").each{|file|
      if  File.size(file) >= @config.pic_size_min and File.size(file) <= @config.pic_size_max then
        #if @config.my_db[:pic].where(:url1=>file).all == [] then
          #print "嫁ゲット\n"
          #print file + "\n"
           #@config.my_db[:pic].insert(:id=>@config.my_db[:pic].max(:id)+1, :url1=>file.encode!("UTF-8"), :size=>File.size(file))
        #end
        # 日付フォルダが無いと作る
        if Dir::exist?(@config.web_pic + date.to_s) == false then
          Dir::mkdir(@config.web_pic + date.to_s)
        end
          p cunt
          p i
          # 日付フォルダにコピーする
          #if rand(100) >= 30 and cunt <= 50 then
          s=0
          #while Dir.glob(@config.web_pic + date.to_s + "/*.*").size <= 50 do
            p s
            begin
              FileUtils.cp(file, @config.web_pic + date.to_s + "/")
            rescue
              p "FileUtils err"
            end
            s=s+1
          #end
          if @config.my_db[:Article_pic].where(:HD_Path=>file).all == [] then 
            FileUtils.cp(file, @config.web_pic + date.to_s + "/")
            #データベースに保存する
            Dir.glob(@config.web_pic + date.to_s + "/*.*").each{|file2|
              if @config.my_db[:Article_pic].where(:HD_Path=>file).all == [] then

                begin
                  @config.my_db[:Article_pic].insert(:id=>@config.my_db[:Article_pic].max(:id)+1, :HD_Path=>file, :HD_WWW_Path=>file2, :WWW_Path=>@config.top_home_page + @config.web_pic + file2.sub("./", ""), :size=>File.size(file), :date=>File.stat(file).mtime, :Create_time=>Time.now())
                rescue
                  p "SQL err"
                  p "======"
                  p file
                  p file2
                  p @config.top_home_page + "Pic/" + file2.sub(@config.web_pic, "")
                end
                 cunt = cunt + 1
              end
           }
          end
          #end
           if Dir.glob(@config.web_pic + date.to_s + "/*.*").size >= 50 then
            break
           end
        i = i + 1
      end
    }
  end

end
@affilete_RssReadr_Kyou_no_yome = Kyou_no_yome.new()
@affilete_RssReadr_Kyou_no_yome.pic_get()
#@affilete_RssReadr_Kyou_no_yome.pic_copy()
