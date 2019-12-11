# -*- encoding: utf-8 -*-


require './3_Config'


class Timer
  # 分刻み
  def initialize(time)
    @time = time
  end
  def get_time()
    time2 = Time.now()
    if (Time.now() - time2) >= @time then
      return true
    else
      return false
    end
    p (Time.now() - time2)
    return false
  end
end


time = Timer.new(10)
loop do
  p time.get_time()
  sleep (1)
end
