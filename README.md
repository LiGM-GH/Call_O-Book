# Call_O-Book
#### _Started as a part of a game about Kolobok_.
This is the simplest parody of markup languages,
the program can be used to process txt files,
marked in accordance with the rules:
 - Before each of the blocks there are two lines: 
	the first with a "%" sign, the second with the word "Act" or "Ask" 
	and the branch number written as 0.a.b.c.d.e and so on, 
	before the words "Act" or "Ask" there must be a number of tabs 
	equal to the number of dots. Blocks 
	not marked in this way are ignored, 
	so they can be considered as comments.
 - There should be TWO new lines 
	at the end of the file. This is necessary 
	for the FileReader to understand that 
	the last block is complete.
 - In the file with the plot, use Act. 
 - In the file with options, if they are needed, 
	each option must be preceded by a line "-", like
```
%
	Ask 0.1.3
-
Sth happens for one or more lines. 
-
Happens sth else
until a blank line 
or a line with a dash 

It's a comment and is not processed. 
One tab is used here. 

```
 - The file now can be combined like
```
%
Act 0
Something changed. 
What to do? 

%
Ask 0
-
Do this? 
-
Or this?
-
Maybe, this?

This line isn't read by program, it's a comment. 
```
 - In addition, there should be a file with standard answers,
like "No such branch" or "No such file".
