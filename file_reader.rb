#~ 	The object of the "FileReader" class
#~ 	reads the file given to it upon initialization
#~ 	with three methods: 
#~ 	this is "read_plot", which reads the text
#~ 	marked up according to the rules for the plot,
#~ 	"read_questions", which reads the text 
#~ 	marked up according to the rules for the questions
#~ 	(the combination of these two markups is now possible), 
#~ 	and "read_standard_answers", which is used to read a given 
#~ 	line in a file (line numbering in a file starts at 1, not 0) 

class FileReader
	def initialize(file, comments)
		@file = file
		@mode = comments
	end
	def read_plot(number)
		if(!File.exist?(@file))
			return "#{@file}: FileNotFound Error"
		end
		@data = File.new(@file)
		@str = nil
		@to_find = "Act " + number + "\n"
		@i = 1
		while(@i<number.length)
			if(number[@i]==".")
				@to_find = "\t" + @to_find
			end
			@i = @i + 1
		end
		while(!@data.eof?)
			@to_return = []
			@str = @data.readline
			if(@str == @to_find)
				# puts @str
				while (@str != "\n")
					if(@mode == "dev")
						@to_return << @str
					else
						if    (@str == "%\n")
							comment = true
						elsif (comment == true)
							comment = false
						elsif(@str != @to_find)
							@to_return << @str
						end
					end
					@str = @data.readline
				end
				@data.close	
				return @to_return
			end
		end
		@data.close	
		@to_return << "read_plot: Plot Not Found"
		return 	@to_return
	end
	def read_questions(number)
		if(!File.exist?(@file))
			return "#{@file}: FileNotFound Error"
		end
		@data = File.new(@file)
		@str = nil
		@to_find = "Ask " + number + "\n"
		@i = 1
		while(@i<number.length)
			if(number[@i]==".")
				@to_find = "\t" + @to_find
			end
			@i = @i + 1
		end
		while(!@data.eof?)
			@to_return = []
			@str = @data.readline
			str = ""
			question = false
			comment = false
			
			if(@str == @to_find)
				while (@str != "\n")
					if(@mode == "dev")
						if    (@str == "%\n")
							comment = true
						elsif (comment == true)
							comment = false
							@to_return << @str
						elsif (@str == "-\n")
							question = true
							@to_return << str
							str = ""
						elsif (question)
							str = str + @str
						end
					elsif(@mode == "usr")
						if    (@str == "%\n")
							comment = true
						elsif (comment == true)
							comment = false
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
			end
		end
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
	def exist?(number)
		if(!File.exist?(@file))
			return "#{@file}: FileNotFound Error"
		end
		@data = File.new(@file)
		@str = nil
		
		to_return_act = false
		@to_find = "Act " + number + "\n"
		@i = 1
		while(@i<number.length)
			if(number[@i]==".")
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
		
		return (to_return_act)
	end
	def ask_exist?(number)
		if(!File.exist?(@file))
			return "#{@file}: FileNotFound Error"
		end
		@data = File.new(@file)
		@str = nil

		to_return_ask = false
		@to_find = "Ask " + number + "\n"
		@i = 1
		while(@i<number.length)
			if(number[@i]==".")
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
		return (to_return_ask)
	end
	def chmod(new_mode)
		@mode = new_mode
	end
end
