# Palescript

## Introduction
Lua is my favorite programming language, due to its small size, blazing speed (especially with LuaJIT), portability, and ease of learning. The language is great. The syntax, however, is beginning to feel a little dated.

The Moonscript project aimed to solve this by writing a new language with its own syntax that compiles back into lua code. It's a great project, and I recommend you take a look at it. However, I feel it diverges too far from Lua's own syntax.

## Enter Palescript
Palescript is a language that is so close to Lua that any current Lua user can immediately start writing with it. The changes are simple, but I think you'll immediately agree that the modern touch makes Lua coding easier.

### What's different?
Not much! The biggest difference is that you no longer have to write 'end' at the end of every block. In Palescript, scope is determined by whitespace, similarly to Python. The code snippets below speak for themselves. While both are short, the code written in Palescript is shorter and more readable due to the lack of end lines.
```lua
-- Palescript
while true do
	print("We're stuck in an infinite loop! D=")
	for i=1, math.huge do
		print("Infinite just got more infinite!!!")

	print("This will never get printed...")

if false then
	print("Nothing?")


-- Lua
while true do
	print("We're stuck in an infinite loop! D=")
	for i=1, math.huge do
		print("Infinite just for more infinite!!!")
	end

	print("This will never get printed...")
end

if false then
	print("Nothing?")
end
```

### Really? Is that all?
Not quite, Palescript also allows you to use the x+= y shortcut you may be used to from other language. (Works for all basic arithmetic operators). And it allows you to use != as a substitution for ~=.
```lua
-- Palescript
foo = 15
foo += 10

if foo != 15 then
	print(foo)

-- Lua
foo = 15
foo = foo + 10

if foo ~= 15 then
	print(foo)
end
```

### Wow, why am I still writing in plain old Lua?
Well, because Lua is still a fantastic language. Also because Palescript isn't ready for primetime use. Palescript is still a very new project, and has many shortcomings.

When I say not ready, I mean **REALLY** not ready. Palescript currently only supports individual files, not entire projects. I plan to have it skim your file's 'require' lines, and compile all of your modules along with your main file. However at the moment, Palescript will only compile the file you directly pass to it.

There are also many edge cases where Palescript will improperly compile your input file. This will not modify or break the input file in any way, but the output fill will fail to run, or not run properly.

If you're interested in playing with the syntax, have any suggestions/feature requests, or just want to test it, please feel free to do so. If you find issues that haven't already been mentioned, please open an Issue. Pull requests welcome.
