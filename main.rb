require_relative "./program_files/file_reader.rb"
require_relative "./program_files/errors.rb"
require_relative "./program_files/game_processor.rb"
include GameProcess
# MAIN:   Say, ask, get, repeat. 
# FUTURE: add name, version, plot file. 
# FUTURE: Needed GUI. 
plot      = "#{__dir__}/program_files/data/plot.txt"
questions = "#{__dir__}/program_files/data/questions.txt"
GameProcessor.new do |game|
  game.start(plot, questions)
  while game.say
    game.ask
    game.get
  end
end
