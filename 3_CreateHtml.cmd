rem call ruby 3_CreateHtml.rb

call curl -# -T e:\\www\index.html -u kyounoyome:X?GF1ytvn@ --ftp-create-dirs -ssl -ftp-ssl -ftp-pasv ftp:\\kyounoyome.x.fc2.com\
     curl -# -T e://www/index.html -u kyounoyome:X?GF1ytvn@ -w "%{url_effective}:%{http_code}\n" --ftp-create-dirs -ftp-ssl -ftp-pasv ftp://kyounoyome.x.fc2.com/
pause