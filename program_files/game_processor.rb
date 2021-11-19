require_relative "file_reader.rb"
#~ Situation table: 
#~   play
#~   end

def get_answer  # Now it's not complicated but we can change it...
  return readline.chomp.downcase
end
def output(sth) # Now it's just puts but maybe it will change...
  puts sth;
end

class GameProcessor
  attr_accessor :situation, :branch, :line

private # Some user funcs

  def dev; @mode = :dev; end
  def usr; @mode = :usr; end
  def help; output "Commands: "; output @commands; end

public

LEFT_BORDER  = '|  '
RIGHT_BORDER = '  |'
LINE_LENGTH  = 40
CHOISE_SIGN  = "{" + " CHOISE ".center(LINE_LENGTH + 4, "=") + "}"
  def initialize # Some constants
    @commands = %w[help dev usr exit]
    @branch = "0"
    @mode   = :usr
    @situation = :play
    yield(self)
  end
  def reform(answer)
    ans_command = false
    @commands.each { |command| ans_command = true if command == answer }
    case
    when ans_command 
      :command
    when @mode == :dev && @teller.find(answer)                 
      # DEBUG: puts "Dev #{answer}"
      answer
    when @mode == :usr && @teller.find(@branch + "." + answer) 
      # DEBUG: puts "Usr #{@branch + '.' + answer}"
      @branch + "." + answer
    else :error
    end
  end
  def start(teller, asker)
    @teller = FileReader.new teller
    @asker  = FileReader.new asker 
  end
  def say
    @teller.get_scene(@branch).each { |line| puts "| " + line + " |" unless line =~ /_*Act_*/ }
    @asker.find @branch
  end
  def ask
    lines = @asker.get_scene @branch
    i = 1
    last = ''
    lines.each do |line| 
      case
      when line == "-"
        print sprintf("%1i: ", i)
        i += 1
      when last == "-"
        puts line.ljust(LINE_LENGTH) + RIGHT_BORDER
      when line =~ /_*Ask_*/
        puts CHOISE_SIGN
      else
        puts LEFT_BORDER + line.ljust(LINE_LENGTH) + RIGHT_BORDER
      end
      last = line
    end
  end
  def get    # Getting answer and some acts caused by it. 
    answer = get_answer
    branch = reform answer
    case branch
    when :command             then eval(answer).inspect
    when :error               then output "No such answer! "
    else @branch = reform answer
    end
    # puts @branch
  end
end
