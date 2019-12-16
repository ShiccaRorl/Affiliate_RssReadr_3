# -*- encoding: utf-8 -*-



class Timer
    def initialize(timer)
        @time = timer
        @time2 = Time.now
    end

    def get_time()
        if (Time.now - @time2) >= @time then
            return true
        end
        return false
    end

    def reset()
        @time2 = Time.now
    end
end


#time = Timer.new(10)
#loop{
#    p time.get_time()
#sleep (1)
#}