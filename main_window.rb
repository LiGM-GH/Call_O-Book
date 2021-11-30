require 'fox16'
include Fox
require "c:/users/lipki/0. Programming/call_o-book/books_call_ruby/" + 
          "v0_1/program_files/game_processor.rb"
include GameProcess
class MainWindow < FXMainWindow
	attr_accessor :istream, :ostream
	def initialize(app, label, i, o)
		super app, label, width: 600, height: 400
		raise "NotArrayIOstream" unless i.class == Array && 
		                                o.class == Array
		@pp = app
		@istream = i
		@ostream = o
		@game = Game.new o, i
		@game.start
		add_menu_bar
		start_text
		@game.say && @game.ask
		text = input
		@text_carrier.setText text, 100
		
	end
	def create
		super
		show PLACEMENT_SCREEN
	end
	def add_menu_bar
		menu_bar = FXMenuBar.new self, LAYOUT_SIDE_TOP | LAYOUT_FILL_X
		file_menu = FXMenuPane.new menu_bar
		title = FXMenuTitle.new menu_bar, 'File', popupMenu: file_menu
		quitbutton = FXMenuCommand.new file_menu, 'Exit. '
		quitbutton.connect SEL_COMMAND do
			exit
		end

		menu1 = FXMenuBar.new self, LAYOUT_SIDE_BOTTOM | LAYOUT_FILL_X
		buttons = []
		4.times do |i| 
			buttons << FXButton.new(menu1, "Variant #{ i + 1 }") 
		end

		buttons.length.times do |i|
			buttons[i].connect SEL_COMMAND do
				output "#{ i + 1 }"
				@game.get
				@game.say && @game.ask
				text = input
				@text_carrier.setText text, 100
				@text_carrier.makePositionVisible @text_carrier.length
			end
		end
	end
	def start_text
		@scroll = FXScrollWindow.new self, LAYOUT_FILL_X|LAYOUT_FILL_Y
		@text_carrier = FXText.new(
			@scroll, 
			opts: TEXT_READONLY|TEXT_WORDWRAP|LAYOUT_FILL_X|LAYOUT_FILL_Y
		)
		monospace = FXFont.new @pp, "Courier New, 120"
		
		@text_carrier.setFont monospace
	end
	def input
		until @istream.any? do
		end
		line = ""
		k = 0
		@istream.each do |str|
			line += str
			k+=1
		end
		@istream.pop k
		return line
	end
	def output(sth)
		@ostream << sth
	end
end

class Game < GameProcessor
	attr_accessor :istream, :ostream
	def initialize(i, o)
		raise "NotArrayIOstream" unless i.class == Array && 
																		o.class == Array
		@istream = i
		@ostream = o
		super
	end
	def input
		until @istream.any? do 
		end
		@istream.pop 
	end
	def output(sth)
		ostream << sth
	end
end

from_game = []
from_gui  = []
if(__FILE__ == $0)
	FXApp.new do |app|
		MainWindow.new(app, "Kolobok_Main", from_game, from_gui)
		app.create
		app.run
	end
end

