class GameProcessor
    def initialize;
        @branch = "0"
        @situation = "play"
        yield(self)
    end
    def start(teller, asker);
        @teller = teller
        @asker  = asker 
    end
    def cycle;  
        while @situation == "play"
            yield
        end
    end
    def say;    end
    def ask;    end
    def get;    end
    def update; end
    def end;    end
end
