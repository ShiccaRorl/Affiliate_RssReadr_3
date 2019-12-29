#! /usr/bin/python3
# coding:utf-8

# pip install python-crontab
# pip install croniter

from crontab import CronTab
import subprocess

class CrontabControl:
    def __init__(self):
        self.cron = CronTab()
        self.job = None
        # ファイルにジョブを書き込むメソッド
    def write_job(self, command, schedule, file_name):
        self.job = self.cron.new(command=command)
        self.job.setall(schedule)
        self.cron.write(file_name)
        # ファイル中のジョブを全て読み込むメソッド
    def read_jobs(self, file_name):
        self.cron = CronTab(tabfile=file_name)
        # ジョブを監視するメソッド
    def monitor_start(self, file):
        # スケジュールを読み込む
        self.read_jobs(file)
        for result in self.cron.run_scheduler():
            # スケジュールになるとこの中の処理が実行される
            subprocess.call('./3_CreateHtml.cmd > ./test.txt')
            print("予定していたスケジュールを実行しました")

#if __name__ == '__main__':



# コマンドを指定
command = './3_CreateHtml.cmd > ./test.txt'
# スケジュールを指定
schedule = '*/1 * * * *'
# ファイルを指定
file = 'A_output.tab'
# インスタンス作成
c = CrontabControl()
# ファイルに書き込む
#c.write_job(command, schedule, file)
# タスクスケジュールの監視を開始
c.monitor_start(file)