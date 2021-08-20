# Call_O-Book
#### _Started as a part of a game about Kolobok_.
This is the simplest parody of markup languages,
the functionality of the program is to process txt files,
marked in accordance with the rules:
 - Before each of the blocks there are two lines: 
	the first with a "%" sign, the second with the word Var 
	and the branch number written as 0.a.b.c.d.e and so on, 
	before the word Var there must be a number of tabs 
	equal to the number of dots. Blocks 
	not marked in this way are ignored, 
	so they can be considered as comments.
 - There should be TWO new lines 
	at the end of the file. This is necessary 
	for the FileReader to understand that 
	the last block is complete.
 - In the file with the plot, no other markup is required.
 - In the file with options, if they are needed, 
	each option must be preceded by a line "-", like
```
%
	Var 1.3
-
Sth happens

One tab is used here - it's a comment and is not processed. 
```

 - In addition, there should be a file with standard answers,
like "No such branch" or "No such file".
