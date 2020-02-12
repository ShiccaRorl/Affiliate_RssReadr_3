:loop
call ruby 3_CreateHtml.rb body
call ruby 3_CreateHtml.rb html_up
rem call 4_アップロード.cmd
rem call 4_アップロード_index.cmd

rem 一時間に一回
rem timeout 3600
timeout 900
goto :loop