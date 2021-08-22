#~ 	The object of the "FileReader" class
#~ 	reads the file given to it upon initialization
#~ 	with three methods: 
#~ 	this is "read_plot", which reads the text
#~ 	marked up according to the rules for the plot,
#~ 	"read_questions", which reads the text 
#~ 	marked up according to the rules for the questions
#~ 	(the combination of these two markups so far not possible), 
#~ 	and "read_standard_answers", which is used to read a given 
#~ 	line in a file (line numbering in a file starts at 1, not 0) 

class FileReader
	def initialize(file, comments)
		@file = file
		@mode = comments
		@con_table_file = "#{File.dirname(@file)}" + 
			"/con_table_#{File.basename(@file)}"
		table_build
										#~  puts table_build
	end
	def read_plot(branch)
		if(!File.exist?(@file))
			return "#{@file}: FileNotFound Error"
		end
										#~  puts "Plot: #{branch}"
		@data = File.new(@file)
		
		@str = nil
		@to_find = "Act " + branch + "\n"
		line_number = table_find(@to_find)
										#~  puts "Plot: #{line_number}"
		@to_return = []
		if(line_number == "#{@con_table_file}: Line Not Found")
			return "read_plot: LineNotFound Error"
		elsif(line_number == "#{@con_table_file}: " + 
				"FileNotFound Error")
			return "read_plot: con_table NotFound"
		end
		i=1
		while(i<line_number)
			@data.readline
										#~  puts "Plot: I: #{i}"
			i+=1
		end
		while(i<branch.length)
			if(branch[i]==".")
				@to_find = "\t" + @to_find
			end
			i += 1
		end
		
		@str = @data.readline
		str = @str
		while (@str != "\n")
			if(@mode == "dev")
				@to_return << @str
			elsif(@str == str)
			elsif(@str == @to_find)
			else
				@to_return << @str
			end
			@str = @data.readline
		end
		@data.close	
		return @to_return
	end
	def read_questions(branch)
		if(!File.exist?(@file))
			return "#{@file}: FileNotFound Error"
		end
		@data = File.new(@file)
		@str = nil
		@to_find = "Ask " + branch + "\n"
		line_number = table_find(@to_find)
		i = 1
		if(line_number == "#{@con_table_file}: Line Not Found")
			return "read_questions: LineNotFound Error"
		elsif(line_number == "#{@con_table_file}: " + 
				"FileNotFound Error")
			return "read_questions: con_table NotFound"
		end
		
		while(i<line_number)
			@data.readline
										#~  puts "Ques: I: #{i}"
			i+=1
		end
		i = 1
		while(i<branch.length)
			if(branch[i]==".")
				@to_find = "\t" + @to_find
			end
			i = i + 1
		end
		@to_return = []
		@str = @data.readline
		str = ""
		question = false
		comment = false
		while (@str != "\n")
			if(@mode == "dev")
				if (@str == "-\n")
					question = true
					@to_return << str
					str = ""
				elsif (question)
					str = str + @str
				end
			elsif(@mode == "usr")
				if(@str == @to_find)
					
				elsif (@str == "-\n")
					question = true
					@to_return << str
					str = ""
				elsif (question)
					str = str + @str
				end
			else
				return "read_questions: WrongArgument" + 
				" in #{__FILE__}: try \"dev\" or \"usr\""
			end
			@str = @data.readline
		end
		@to_return << str
		@data.close	
		return @to_return
	
		@data.close	
		return "read_questions: Question Not Found"	
	end
	def read_standart_answers(ans_code)
		if(!File.exist?(@file))
			return "#{@file}: FileNotFound Error"
		end
		@data = File.new(@file)
		@str = nil
		@counter = 0
		while(!@data.eof?)
			if(@counter >= ans_code)
				@data.close
				return @str.chomp
			end
			@str = @data.readline
			@counter += 1
		end
		@data.close
		return "ReadStandartAnswers: Line Not Found"
		
	end
	def exist?(branch)
		if(!File.exist?(@file))
			return "#{@file}: FileNotFound Error"
		end
		@data = File.new(@file)
		@str = nil
		
		to_return_act = false
		@to_find = "Act " + branch + "\n"
		@i = 1
		while(@i<branch.length)
			if(branch[@i]==".")
				@to_find = "\t" + @to_find
			end
			@i = @i + 1
		end
		while(!@data.eof?)
			@str = @data.readline
			if(@to_find == @str)
				to_return_act = true
			end
		end
		@data.close
		return (to_return_act)
	end
	def ask_exist?(branch)
		if(!File.exist?(@file))
			return "#{@file}: FileNotFound Error"
		end
		@data = File.new(@file)
		@str = nil

		to_return_ask = false
		@to_find = "Ask " + branch + "\n"
		@i = 1
		while(@i<branch.length)
			if(branch[@i]==".")
				@to_find = "\t" + @to_find
			end
			@i = @i + 1
		end
		while(!@data.eof?)
			@str = @data.readline
			if(@to_find == @str)
				to_return_ask = true
			end
		end
		@data.close
		return (to_return_ask)
	end
	def chmod(new_mode)
		@mode = new_mode
	end
	def no_tabs(line)
		line_array = []
		for i in 0..(line.length-1)
			line_array << line.chomp[i]
		end
		line_array.delete("\t")
										#~  puts line_array.to_s
		line = ""
		for i in 0..(line_array.length-1)
			if(line_array[i]!=nil)
				line += line_array[i]
			end
		end
		return line
	end
	def is_branch?(line)
		line = no_tabs(line)
		if(
			("#{line[0]}" + "#{line[1]}" + "#{line[2]}" == "Act") || 
			("#{line[0]}" + "#{line[1]}" + "#{line[2]}" == "Ask")
		)
			return true
		else
			return false
		end
	end
	def table_build()
		if(!File.exist?(@file))
			return "#{@file}: FileNotFound Error"
		end
		@data = File.new(@file)
		@str = nil
		counter = 0
		@con_table_object = File.new("#{@con_table_file}", 'w') 
		while(!@data.eof?)
			counter += 1
			line = @data.readline
			if(is_branch?(line))
				@con_table_object.write(
				"#{no_tabs(line)}\n#{counter}\n"
				)
			end
		end
		@data.close
		@con_table_object.close
		return("built #{@con_table_file}")
	end
	def table_find(line)
										#~  puts "Find: #{line}"
		if(!File.exist?(@con_table_file))
			return "#{@con_table_file}: " + 
				"FileNotFound Error"
		end
		@con_table_object = File.new(@con_table_file)
		line = line.chomp
		table_str = @con_table_object.readline.chomp
		while((table_str != "\n")&&(!@con_table_object.eof?)) 
										#~  puts "Find: #{table_str}"
			if(line == table_str)
				table_str = @con_table_object.readline.chomp
				@con_table_object.close
										#~  puts "Find: #{table_str}"
				return table_str.to_i
			end
			if(!@con_table_object.eof?)
				table_str = @con_table_object.readline.chomp
			end
		end 
		@con_table_object.close
		return "#{@con_table_file}: Line Not Found"
	end
end

