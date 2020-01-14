# 現在（今年）のCLMをバックアップする
# このスクリプトバックアップ対象ファイルはと同じディレクトリに置くこと
# 引数として、バックアップ間隔を秒単位で指定する


import os, sys
import signal
from traceback import format_exc

import re, time, shutil
import tkinter as tk
import tkinter.messagebox as tkmbx

LOCKFILE = 'CLM_BKUP_EXIST.lock'

BKUP_DIR = "C:\\home\\bkup"
INTENDED_FILE = ["{}01\d\d[-].clm$".format(time.strftime("%y"))]
SOURCE_DIR_NAME = "CLM"

# カスタム例外: プログラム内部でraiseされるエラー
class ClmBkup_InternalError(Exception):
    def __init__(self, errmsg):
        self.errmsg = errmsg
        
    def __str__(self):
        return self.errmsg

# カスタム例外: 二重起動防止用
class ClmBkup_AlreadyStarted(Exception):
    def __str__(self):
        return "Clm_Backup is already started."

# カスタム例外: 終了（--quitオプション実行時）
class ClmBkup_Quit(Exception): pass

# 何か起こったらメッセージボックスでエラーを伝える
def error_dialog(msg):
    ed = tk.Tk()
    ed.withdraw()

    tkmbx.showinfo("CLM BACKUP ERROR", "Backup process failed.\n" +
                   "\nErr: {}".format(msg))

# --quitオプションで終了した時のダイアログ
def quit_dialog():
    ed = tk.Tk()
    ed.withdraw()

    tkmbx.showinfo("CLM BACKUP QUITED", "Clm_Backup quitted successfully.")

# カレントディレクトリ内の指定されたファイルを探して、そのリストを返す
def init():
    match_file = []
    if os.path.basename(os.getcwd()) != SOURCE_DIR_NAME:
        raise ClmBkup_InternalError("Wrong directry.\n" +
         "This program should be placed in '{}' folder.".format(SOURCE_DIR_NAME))

    for ifile in INTENDED_FILE:
        for f in (f for f in os.listdir() if re.match(ifile, f)):
            match_file.append(f)

    if len(match_file) == 0:
        raise ClmBkup_InternalError("The intended file does not exist.")

    return match_file

# バックアップは、指定されたバックアップディレクトリにまるっとコピーする形で
def backup(match_file):
    for src in match_file:
        shutil.copy2(os.path.join('.', src), BKUP_DIR)

# main
# ロックファイルが存在しない＝最初の起動であると判断する。
# ロックファイルが存在する＝二重起動であると判断して終了する。
# 二重起動時以外で終了（例外やエラーが発生した場合）したらロックファイルを削除
# バックアッププロセスがある間はロックファイルを開きっぱなしにする

if __name__ == '__main__':
    try:
        if os.path.exists(LOCKFILE):
            if sys.argv[1] == '--quit':
                with open(LOCKFILE, encoding='utf-8') as lf:
                    for l in (l for l in lf if l.isdigit()):
                        clmbkup_pid = int(l.strip())
                        break

                # 注： Windowsでのos.kill()のサポートは3.2以降
                os.kill(clmbkup_pid, signal.SIGTERM)
                raise ClmBkup_Quit

            else:
                raise ClmBkup_AlreadyStarted

        # ロックファイルの生成
        with open(LOCKFILE, mode='w+', encoding='utf-8') as lf:
            lf.write(str(os.getpid()))
            print(os.getpid())

        with open(LOCKFILE):  # ロックファイルをロック
            if len(sys.argv) <= 1:
                raise ClmBkup_InternalError("This program require one argument.") 

            if not sys.argv[1].isdigit():
                raise ClmBkup_InternalError(
                    "Invalid argument.\n" +
                    "Argument must be integer or float value.")

            interval = float(sys.argv[1])
            match_file = init()
    
            while True:
                    backup(match_file)
                    time.sleep(interval)

    except ClmBkup_InternalError as err:
        error_dialog(err)
        os.remove(LOCKFILE)

    except ClmBkup_AlreadyStarted as err:
        error_dialog(err)

    except ClmBkup_Quit:
        quit_dialog()
        if os.path.exists(LOCKFILE):
            os.remove(LOCKFILE)

    except:
        error_dialog(format_exc())
        os.remove(LOCKFILE)