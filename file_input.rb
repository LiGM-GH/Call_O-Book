# FileReader.read_... обладает тремя параметрами: 
# это файл, который нужно открыть, пункт, который нужно найти, 
# и режим открытия - один из двух вариантов, "dev" или "usr". 
# "dev" передаёт полное содержимое, "usr" - только
# то, что нужно программе - текст без разметки и 
# указания номера ветви. 
# FileReader.exist? обладает теми же параметрами, 
# и возвращает наличие строки. 
# 

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
		@to_find = "Var " + number + "\n"
		@i = 1
		while(@i<number.length)
			if(number[@i]!=".")
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
		@to_find = "Var " + number + "\n"
		@i = 1
		while(@i<number.length)
			if(number[@i]!=".")
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
		@to_find = "Var " + number + "\n"
		@i = 1
		while(@i<number.length)
			if(number[@i]!=".")
				@to_find = "\t" + @to_find
			end
			@i = @i + 1
		end
		while(!@data.eof?)
			@str = @data.readline
			if(@to_find == @str)
				return true
			end
		end
		return false
	end
	def chmod(new_mode)
		@mode = new_mode
	end
end
