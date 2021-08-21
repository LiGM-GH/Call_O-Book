require_relative "file_reader.rb"
require_relative "input_output.rb"
require_relative "functions_and_constants.rb"
begin # Nesessary here functions and constants. 
#~ Setup: 
#~ 	interface: user, 
#~ 	printing letters with delay: little_delay,
#~ 	printing blocks delay: big_delay. 

#~  File reading:
#~  	Questions from questions.txt, 
#~  	Plot from plot.txt, 
#~  	Standard answers from standard_answers.txt. 
begin
	mode = "usr"
	little_delay = 0.001
	big_delay = 0.5
	branch = "0"
end
teller  = FileReader.new(
	File.dirname(__FILE__) + 
	"/data/plot.txt", mode
)
asker   = FileReader.new(
	File.dirname(__FILE__) + 
	"/data/questions.txt", mode
)
std_ans = FileReader.new(
	File.dirname(__FILE__) + 
	"/data/standart_answers.txt", mode
)

end

name = game_name(std_ans, little_delay)
if(name == "dev")
	mode = "dev"
	teller.chmod("dev")
	 asker.chmod("dev")
	little_delay = 0
	big_delay = 0
elsif(name == "usr")
	mode = "usr"
	teller.chmod("usr")
	 asker.chmod("usr")
	little_delay = 0.005
	big_delay = 0.5
elsif(name == "exit")
	game_end
elsif(name == "help")
	game_help(std_ans)
end
say_flag = game_say(teller, branch, little_delay)
sleep big_delay
ask_flag = game_ask(asker,  branch, little_delay)

while(teller.exist?(branch))
	choice = input.downcase
	if(choice == "dev")
		begin
			mode = "dev"
			teller.chmod("dev")
			 asker.chmod("dev")
			little_delay = 0
			big_delay = 0
		end
	elsif(choice == "usr")
		begin
			mode = "usr"
			teller.chmod("usr")
			 asker.chmod("usr")
			little_delay = 0.005
			big_delay = 0.5
		end
	elsif(choice == "exit")
		game_end
	elsif(choice == "help")
		game_help(std_ans)
	elsif((mode == "usr") && !teller.exist?(branch+"."+choice))
		game_type_error(std_ans, little_delay)
	elsif((mode == "dev") && !teller.exist?(choice))
		game_type_error(std_ans, little_delay)
	else
		if(mode == "dev")
			branch = choice
		else
			branch = branch + "." + choice
		end
		say_flag = game_say(teller, branch, little_delay)
		sleep big_delay
		ask_flag = game_ask(asker, branch, little_delay)
		
		if   (say_flag == "Win")
			game_win(std_ans, little_delay)
		elsif(say_flag == "End")
			game_over(std_ans, little_delay)
		end
	end
end
game_end
