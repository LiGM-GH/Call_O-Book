require_relative "contents_table_manager.rb"
class FileReader < ContentsTableManager
    def initialize(file)
        super(file)
        @file_string = file
    end
end
#~  FileReader.new("#{File.dirname(__FILE__)}/data/plot.txt")
