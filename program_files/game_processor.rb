module GameProcess
  require_relative "file_reader.rb"
  #~ Situation table: 
  #~   play
  #~   end

  ENDBRANCH    = '1'
  LEFT_BORDER  = '|  '
  RIGHT_BORDER = "  |\n"
  LINE_LENGTH  = 50
  CHOISE_SIGN  = "{" + " CHOISE ".center(LINE_LENGTH + 4, "=") + "}\n"
  END_SIGN     = "{" +    " END ".center(LINE_LENGTH + 4, "=") + "}\n"
  WIN_SIGN     = "{" +    " WIN ".center(LINE_LENGTH + 4, "=") + "}\n"
  BUILTIN_PLOT      = "#{__dir__}/data/plot.txt"
  BUILTIN_QUESTIONS = "#{__dir__}/data/questions.txt"
  ENDL = "\n"

  class GameProcessor
    attr_accessor :situation, :branch, :line

  private # Some user funcs

    def dev; @mode = :dev; end
    def usr; @mode = :usr; end
    def help; output "Commands: "; output @commands; end
    def quit; @branch = ENDBRANCH; end

  public

    def input           # Now it's not complicated but we can change it...
      return readline.chomp.downcase
    end
    def output(sth)     # Now it's just puts but maybe it will change...
      puts sth;
    end
    def initialize(*a)  # Some constants
      @commands  = %w[help dev usr quit exit]
      @branch    = "0"
      @mode      = :usr
      @situation = :play
      yield(self) if block_given?
    end
    def reform(answer)
      ans_command = false
      @commands.each { |command| ans_command = true if command == answer }
      case
      when @branch == ENDBRANCH then @branch
      when ans_command          then :command
      when @mode == :dev && @teller.find(answer)
        # DEBUG: puts "Dev #{answer}"
        answer
      when @mode == :usr && @teller.find(@branch + "." + answer) 
        # DEBUG: puts "Usr #{@branch + '.' + answer}"
        @branch + "." + answer
      else :error
      end
    end
    def start(teller = BUILTIN_PLOT, asker = BUILTIN_QUESTIONS)
      @teller = FileReader.new teller
      @asker  = FileReader.new asker 
    end
    def say
      result = ""
      if @branch == ENDBRANCH
        return false
      else
        @teller.get_scene(@branch).each do |line| 
          if line =~ /_*End_*/ 
            result += END_SIGN
            break
          elsif line =~ /_*Win_*/
            result += WIN_SIGN
            break
          elsif (line =~ /_*Act_*/)
            if @mode == :dev
              # puts line.scan(/Act [0-9.]*/)
              result += LEFT_BORDER + 
                line.scan(/Act [0-9.]*/)[0].ljust(LINE_LENGTH) + RIGHT_BORDER
            end
          else
            result += LEFT_BORDER + line.ljust(LINE_LENGTH) + RIGHT_BORDER 
          end
        end
        output result
        return @asker.find @branch
      end
    end
    def ask
      lines = @asker.get_scene @branch
      i = 1
      result = ""
      last = ''
      lines.each do |line| 
        case
        when line == "-"
          result += sprintf("%1i: ", i)
          i += 1
        when last == "-"
          result += line.ljust(LINE_LENGTH) + RIGHT_BORDER
        when line =~ /_*Ask_*/
          result += CHOISE_SIGN
        else
          result += LEFT_BORDER + line.ljust(LINE_LENGTH) + 
                      RIGHT_BORDER
        end
        last = line
      end
      output result
    end
    def get    # Getting answer and some acts caused by it. 
      answer = input
      branch = reform answer
      case branch
      when :command then eval(answer).inspect
      when :error   then output "No such answer! \n"
      else @branch = reform answer
      end
      # puts @branch
    end
  end
end
