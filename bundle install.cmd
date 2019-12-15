rem gemアップデート
rem call gem update --system
rem call gem update bundler

rem 最近のアップデートの仕方
rem call gem install rubygems-update
rem call update_rubygems
rem call gem update
rem call gem cleanup

rem コマンドインストール
rem call bundle update
rem call bundle --system

rem bundlerのインストール
rem call gem install bundler



rem gemファイル作成
rem    call gem build Charu.gemspec

rem アップロード
rem call gem push .\pkg\Charu-0.0.6.gem

rem いっぱいアップロード
rem call bundle exec Charu GemUPLoder

rem Gemのインストール
rem call gem install Charu

rem call git add file_name
call git commit -m "fast"
call git push

rem ShiccaRorl
rem aniki1119

rem 最近のgemの作り方
call bundle exec rake release

	
rem bundle install
call bundle install --path vendor/bundle
call bundle clean

	
	
REM otintin.land.waai@gmail.com

pause
