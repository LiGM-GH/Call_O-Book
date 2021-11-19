require_relative "contents_table_manager.rb"
require_relative "errors.rb"
class FileReader < ContentsTableManager
  attr_accessor :file_string, :table_string
  def initialize(file)
    super(file)
  end
  def find(branch)
    i = 0
    File.open(table_string, 'r') do |file|
      line = ""
      until file.eof? || line == 'Act ' + branch + "\n" || line == 'Ask ' + branch + "\n"
        line = file.readline
      end 
      if line == 'Act ' + branch + "\n" || line == 'Ask ' + branch + "\n"
        i = file.readline.to_i
      else
        # puts line
        return false
      end
    end
    # puts "line: #{i}"
    i
  end
  def get_scene(branch)
    str = []
    if (line = find branch)
      File.open file_string, 'r' do |file|
        line.times { file.readline } # Skip to line
        str << line.chomp until (line = file.readline) == "\n"
      end
    else raise NoLineError.new(""), "No such line!"
    end
    str
  end
end
