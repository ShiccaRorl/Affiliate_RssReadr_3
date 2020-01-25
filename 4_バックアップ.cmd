REM @echo off


REM date環境変数から日付の数字だけを抽出する

REM 　以上の書式を使えば、「2015/07/01」のような文字列の入ったdate変数から数字の部分だけを抜き出すには、

REM     年： 先頭から、4文字分
REM     月： 先頭より6文字目から、2文字分
REM     日： 先頭より9文字目から、2文字分

REM %date:~0,4%%date:~5,2%%date:~8,2%


REM 圧縮

REM C:\7za.exe a C:\圧縮後ファイル名.zip C:\圧縮前ファイル名.txt


REM 7-Zip [64] 4.65  Copyright (c) 1999-2009 Igor Pavlov  2009-02-03

REM 使用法: 7z <コマンド> [<スイッチ>...] <書庫ファイル> [<書庫ファイル>...]
REM  [<@リストファイル...>]

REM <コマンド>
REM  a: 書庫にファイルを追加する。Add files to archive
REM  b: ベンチマーク。Benchmark
REM  d: 書庫からファイルを削除する。Delete files from archive
REM  e: 書庫からファイルを取り出す（ディレクトリ名なし）。Extract files from archive (without using directory names)
REM  l: 書庫内の内容一覧を表示。List contents of archive
REM  t: 書庫の完全性をテストする。Test integrity of archive
REM  u: 書庫のファイルを更新する。Update files to archive
REM  x: フルパスでファイルを取り出す。eXtract files with full paths
REM <スイッチ>
REM  -ai[r[-|0]]{@リストファイル|!ワイルドカード}: 書庫に含める。 Include archives
REM  -ax[r[-|0]]{@リストファイル|!ワイルドカード}: 書庫から除外する。eXclude archives
REM  -bd: パーセント表示を無効にする。Disable percentage indicator
REM  -i[r[-|0]]{@リストファイル|!ワイルドカード}: ファイル名を含める。Include filenames
REM  -m{パラメータ}: 圧縮方法を設定する。set compression Method
REM  -o{ディレクトリ}: 出力ディレクトリを設定する。set Output directory
REM  -p{パスワード}: パスワードを設定する。set Password
REM  -r[-|0]: サブディレクトリも再帰的に実行する。Recurse subdirectories
REM  -scs{UTF-8 | WIN | DOS}: 一覧ファイルの文字コードを設定する。set charset for list files
REM  -sfx[{名前}]: 自己解凍書庫を作成する。Create SFX archive
REM  -si[{名前}]: 標準入力からデータを読む。read data from stdin
REM  -slt: ｌ（リスト）コマンドに技術情報を表示する。show technical information for l (List) command
REM  -so: データを標準出力に書く。write data to stdout
REM  -ssc[-]: 大文字と小文字を区別する。set sensitive case mode
REM  -ssw: 共有ファイルを圧縮する。compress shared files
REM  -t{Type}: 書庫のタイプを設定する。Set type of archive
REM  -v{Size}[b|k|m|g]: ボリュームを作成する。Create volumes
REM  -u[-][p#][q#][r#][x#][y#][z#][!newArchiveName]: 更新オプション。Update options
REM  -w[{path}]: 作業ディレクトリを指定する。空欄なら一時ディレクトリとみなす。assign Work directory. Empty path means a temporary directory
REM  -x[r[-|0]]]{@リストファイル|!ワイルドカード}: ファイルを実行する。eXclude filenames
REM  -y: 質問にYesと答えるものとして実行する。assume Yes on all queries



.\..\tool\7z\7za.exe a C:\Affiliate_RssReadr_3\Affiliate_Data.SQLite3_%date:~0,4%-%date:~5,2%-%date:~8,2%.7z C:\Affiliate_RssReadr_3\Affiliate_Data.SQLite3 -r -w.\ -ssc -ssw -mx=9 -mfb=128 -y
.\..\tool\7z\7za.exe a C:\Affiliate_RssReadr_3\RssData.SQLite3_%date:~0,4%-%date:~5,2%-%date:~8,2%.7z C:\Affiliate_RssReadr_3\RssData.SQLite3 -r -w.\ -ssc -ssw -mx=9 -mfb=128 -y
