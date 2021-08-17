class FileReader
	def read_plot(file, number, comments)
		if(!File.exist?(file))
			return "plot: FileNotFound Error"
		end
		@data = File.new(file)
		@counter = 0
		while (@counter < number)
			@to_return = []
			@str = @data.readline
			while (@str != "\n")
				if(comments == "comments")
					@to_return << @str
				else
					if    (@str == "%\n")
						flag = true
					elsif (flag == true)
						flag = false
					else
						@to_return << @str
					end
				end
				@str = @data.readline
			end
			@counter = @counter + 1
		end
		@data.close	
		return @to_return	
	end
	def read_questions(file, number, comments)
		if(!File.exist?(file))
			return "questions: FileNotFound Error"
		end
		@data = File.new(file)
		@counter = 0
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
					if(comments == "comments")
						@to_return << @str
					else
						if    (@str == "%\n")
							comment = true
						elsif (comment == true)
							comment = false
						elsif (@str == "-\n")
							question = true
						elsif (question)
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
		return "read_questions: Question Not Found"	
	end
end
