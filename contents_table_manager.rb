require_relative "errors.rb"
def delete_tabs(line)
    array_from_line = []; i = 0;
    while(i<line.length) do array_from_line << line[i]; i+=1; end 
    array_from_line.delete("\t"); line = ""; 
    array_from_line.each do |character| line += character; end
    return line
end
class ContentsTableManager
    def initialize(file)
        @given_file_string = file
        @table_file_string = "#{File.basename(file, '.*')}_contents_table.txt"
        build
    end
    def get_file_name;  return @given_file_string; end
    def get_table_name; return @table_file_string; end
    def build
        output = 0
        given_file_object = File.new(@given_file_string, 'r')
        #~  Здесь должно быть чтение исходного файла. 
        lines_to_contents_table = []
        begin
            line_from_file = given_file_object.readline.chomp
            if(line_from_file =~ /_*Act [0..9.]*/) then lines_to_contents_table << delete_tabs(line_from_file); end
            #~  lines_to_contents_table << line_from_file
            if(given_file_object.eof) then puts "AAA"; end
        end while (!given_file_object.eof)
        output = 0
        
        #~  Заглушка. Тут имеется в виду запись не на экран, а в оглавление. 
        puts lines_to_contents_table
        
        given_file_object.close; return output
        
    end
end

