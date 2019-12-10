# -*- encoding: utf-8 -*-

require "csv"
require "./3_Config"
require "fileutils"

@config = Config.new()

@gazous = []

# 本体からコピーする
print "本体をコピーしています。\n"
system("xcopy #{@config.c_source_scrapBook}* #{@config.c_scrapBook} /S /E /I /L /Y")

# 本体削除
print "本体を削除しています。\n"
#Dir.glob(@config.source_scrapBook + '**/*').each do |filename|
#    FileUtils.rm(filename)
#end
system("rd /s /q #{@config.c_source_scrapBook}")


print "不要ファイルを削除しています。\n"
# キャシュとか削除する
Dir.glob(@config.scrapBook + '**/*.html').each do |filename|
	FileUtils.rm(filename)
end

Dir.glob(@config.scrapBook + '**/*.ico').each do |filename|
	FileUtils.rm(filename)
end

Dir.glob(@config.scrapBook + '**/*.js').each do |filename|
	FileUtils.rm(filename)
end

# サムネイルらしいのを削除する
Dir.glob(@config.scrapBook + '**/*s.*').each do |filename|
	FileUtils.rm(filename)
end



# ファイルサイズが小さいと削除
Dir.glob(@config.scrapBook + '**/*.*').each do |filename|
    # print filename + "\n"
    if @config.file_size > File.size(filename) then
        print filename + "  " + File.size(filename).to_s + "\n"
        FileUtils.rm(filename)
    end
end

#system("xcopy #{@config.c_scrapBook} #{@config.c_gazou_path}#{Time.now.strftime('%Y-%m-%d')}\\ /S /E /I /L /Y")

# 画像の追加
@gazous << Dir.glob("#{@config.scrapBook}**/*.jpeg")
@gazous << Dir.glob("#{@config.scrapBook}**/*.JPEG")
@gazous << Dir.glob("#{@config.scrapBook}**/*.jpg")
@gazous << Dir.glob("#{@config.scrapBook}**/*.JPG")
@gazous << Dir.glob("#{@config.scrapBook}**/*.GIF")
@gazous << Dir.glob("#{@config.scrapBook}**/*.gif")
@gazous << Dir.glob("#{@config.scrapBook}**/*.PNG")
@gazous << Dir.glob("#{@config.scrapBook}**/*.png")


# CSVで出力
CSV.open('gazou_inport.csv','w') do |gazou|
    @gazous.each{|path|
        path.each{|pat|
            #compressed_file_size = File.size(pat).to_f / 2**20
            #gazou_saizu = '%.2f' % compressed_file_size
            gazou_saizu = File.size(pat)
            #.strftime("%Y-%m-%d %H:%M:%S %A")
            gazou << [pat, gazou_saizu, Time.now.strftime("%Y-%m-%d %H:%M:%S")]
        }
    }
end


