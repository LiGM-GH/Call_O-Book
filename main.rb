require_relative "./program_files/file_reader.rb"
require_relative "./program_files/errors.rb"
require_relative "./program_files/game_processor.rb"

#~  Что нужно сделать? 
#~  Берём файл, читаем, выводим вопросы, вводим ответы. 
#~  Как читаем - без разницы, как выводим - без разницы. 
#~  Как вводим ответы - без разницы. 

#~  Главное:    читаем, спрашиваем, слушаем, повторяем. 
#~  На_будущее: можно добавить выбор имени, версии, файла сюжета. 
#~  На_будущее: нужно добавить GUI. 

GameProcessor.new do |game|
    game.start(
        "./program_files/data/plot.txt", 
        "./program_files/data/questions.txt"
    )
    game.cycle do 
        game.say;
        game.ask;
        game.get;
        game.update;
    end
    game.end
end
