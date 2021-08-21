require_relative "file_reader.rb"
require_relative "input_output.rb"
begin
	def game_say (reader, branch, delay)
		to_tell = reader.read_plot(branch)
		if(to_tell == "read_plot: Plot Not Found")
			return 0
		else
			return story_say(to_tell, delay)
		end
	end
	def game_ask (reader, branch, delay)
		to_tell = reader.read_questions(branch)
		if(to_tell == "read_questions: Question Not Found")
			return false
		else
			story_ask(to_tell, delay)
			return true
		end
	end
	def game_name(reader, delay)
		system_out(reader.read_standart_answers(5), delay)
		system_out(reader.read_standart_answers(6), delay)
		return input
	end
	def game_win (reader, delay)
		system_out(reader.read_standart_answers(2), delay)
		game_end
	end
	def game_over(reader, delay)
		system_out(reader.read_standart_answers(1), delay)
		game_end
	end
	def	game_type_error(reader, delay)
		system_out(reader.read_standart_answers(3), delay)
		system_out(reader.read_standart_answers(4), delay)
	end
	def game_help(reader)
		system_out(reader.read_standart_answers(8),  0)
		system_out(reader.read_standart_answers(9),  0)
		system_out(reader.read_standart_answers(10), 0)
		system_out(reader.read_standart_answers(11), 0)
	end
end
