# pip install python-crontab
# pip install croniter

from crontab import CronTab
import A_ClonTab

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
            print("予定していたスケジュールを実行しました")



# コマンドを指定
command = './3_CreateHtml.cmd'
# スケジュールを指定
schedule = '60 * * * *'
# ファイルを指定
file = 'A_output.tab'
# インスタンス作成
c = CrontabControl()
# ファイルに書き込む
c.read_jobs(file)
#c.write_job(command, schedule, file)
# タスクスケジュールの監視を開始
c.monitor_start(file)