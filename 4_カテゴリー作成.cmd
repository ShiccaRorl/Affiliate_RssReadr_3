
:loop
call ruby 3_CreateHtml.rb category

rem 一日に一回
timeout 86400
goto :loop