# -*- encoding: utf-8 -*-



class Timer
    def initialize(timer)
        @time = timer
        @time2 = Time.now
        @count = 0
    end

    def get_time()
        if (Time.now - @time2) >= @time then
            #p Time.now - @time2
            return false
        elsif @count == 0 then
            return true
        else
            @count = @count + 1
            sleep(1)
            return true
        end
        return true
    end

    def reset()
        @time2 = Time.now
    end
end