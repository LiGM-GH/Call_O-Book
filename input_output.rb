def input()
	return gets.chomp
end

def output(stroka, time)
	print "[ "
	sleep time
	for i in 0..stroka.length
		print stroka[i]
		sleep time
	end
	print " ]\n"
	sleep time
end

def ask(stroka, time)
	print "< "
	sleep time
	for i in 0..stroka.length
		if(i + 1 <= stroka.length)
			if(stroka[i+1] == "\n")
				print "..\\"
			end
		end
		print stroka[i]
		if(stroka[i]=="\n")
			print "\\  .."
		end
		sleep time
	end
	print " >\n"
	sleep time
end

def system_out(stroka, time)
	print "{ "
	sleep time
	for i in 0..stroka.length
		if(i + 1 <= stroka.length)
			if(stroka[i+1] == "\n")
				print "..\\"
			end
		end
		print stroka[i]
		if(stroka[i]=="\n")
			print "\\  .."
		end
		sleep time
	end
	print " }\n"
	sleep time
end

def game_end()
	system_out("Для продолжения нажмите enter.            ", 0)
	gets
	exit
end

def story_say(array, delay)
	if(array == "read_plot: Plot Not Found")
		output(array, 0)
	elsif(
		(array[array.length-1].chomp == "Win")||
		(array[array.length-1].chomp == "End")
	)
		for i in 0..(array.length-2)
			output(array[i].chomp, delay)
		end
		return array[array.length-1].chomp
	else
		for i in array
			output(i.chomp, delay)
		end
		return 1
	end
end

def story_ask(array, delay)
	if(array == "read_questions: Question Not Found")
		output(array, 0)
	else
		for i in 1..(array.length-1)
			ask("#{i}. " + array[i].chomp, delay)
		end
	end
end
