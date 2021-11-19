require_relative "errors.rb"
def delete_tabs(line)
  array_from_line = []
  i = 0
  while(i<line.length) do 
    array_from_line << line[i]
    i += 1
  end 
  array_from_line.delete("\t")
  line = ""
  array_from_line.each { |character| line += character }
  line
end
def add_tabs(line)
  array_from_line = []
  i = 0
  line.length.times do |i|
    if(line[i]==".") 
      array_from_line << "\t"
      i+=1
    end
  end
  i = 0
  while(i<line.length) do 
    array_from_line << line[i]
    i+=1
  end 
  array_from_line.each { |character| line += character }
  line
end
class ContentsTableManager
  attr_accessor :file_string, :table_string
  def initialize(file)
    @file_string = file
    @table_string = "#{File.dirname(file)}/#{File.basename(file, '.*')}_contents_table.txt"
    build
  end
  def build
    number = 0
    lines_to_contents_table = []
    File.open(@file_string, 'r') do |file|
      begin
        #~  Reading the file
        line = file.readline.chomp
        lines_to_contents_table << delete_tabs(line) << number if line =~ /_*Act [0-9.]*_*/ || line =~ /_*Ask [0-9]*_*/
        number += 1
      end until (file.eof?)
    end
    File.open(@table_string, 'w') { |file| file.puts lines_to_contents_table }
  end
end
