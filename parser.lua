#!/bin/lua5.1

local argparse = require "argparse"
local parser = argparse("script", "Palescript Compiler")

parser:argument("input", "Input file.")
parser:option("-o --output", "Output file.")
parser:option("-i --interpreter", "Interpreter to pass output to.", "lua5.1")
parser:flag("-e --execute", "Run lua output after conversion.")

local args = parser:parse()

local function countChar(input, char)
	local _, count
	if string.find(input, '.') then
		_, count = string.find(input, char)
		if count == nil then count = 0 end
	else
		return nil
	end

	return count
end

local function find(line, pattern)
	-- Function calls string.find, ignoring commented lines
	local commentLocation = string.find(line, '%-%-')
	if commentLocation then
		local code = string.sub(line, 1, commentLocation - 1)
		return string.find(code, pattern)
	else
		return string.find(line, pattern)
	end
end

local function statementType(line)
	if find(line, 'if%s.*:$') then
		return 'if'
	elseif find(line, 'while%s.*:$') then
		return 'while'
	elseif find(line, 'for%s.*:$') then
		return 'for'
	elseif find(line, 'function%s.*:$') then
		return 'function'
	elseif find(line, 'else:$') then
		return 'else'
	elseif find(line, 'elseif%s.*:$') then
		return 'elseif'
	end
end

local function split(str, pat)
	local t = {}
	local fpat = "(.-)" .. pat
	local last_end = 1
	local s, e, cap = str:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = str:find(fpat, last_end)
	end
	if last_end <= #str then
		cap = str:sub(last_end)
		table.insert(t, cap)
	end

	return t
end

local function endLines(start, finish, buffer)
	for i=start, finish+1, -1 do
		local output = ""
		for j=i-1, 1, -1 do
			output = output..'\t'
		end
		output = output..'end'
		table.insert(buffer, output)
	end
end

local function prevLine(indent, line)
	local prev
	local blankLines = 0
	for i=line-1, 1, -1 do
		if indent[i] ~= nil then
			prev = i
			break
		else
			blankLines = blankLines + 1
		end
	end

	return prev, blankLines
end


local function loadFiles(inputPath, outputPath)
	local input = io.open(inputPath, 'r')
	local text = split(input:read('*all'), '\n')

	local output
	if outputPath then
		output = io.open(outputPath, 'w')
	else
		outputPath = os.tmpname()
		output = io.open(outputPath, 'w')
	end

	local indent ={}
	for i, line in pairs(text) do
		indent[i] = countChar(line, '^\t+')
	end

	return text, output, outputPath, indent
end

local function writeOutput(text, output)
	for _, line in pairs(text) do
		output:write(line..'\n')
	end
end

local function checkIndentation(text, indent)
	for curr=2, #text do
		local prev = prevLine(indent, curr)

		-- Check indentation
		if indent[curr] then
			local statement = statementType(text[prev])
			if statement then
				if indent[curr] ~= indent[prev]+1 then
					return false, "Indent expected at line "..curr
				end
			else
				if indent[curr] > indent[prev] then
					return false, "Unexpected indentation at line "..curr
				end
			end
		end
	end

	return true
end

local function compile(text, indent, ...)
	local modifiers = {...}
	local buffer = text

	for _, modifier in pairs(modifiers) do
		buffer = modifier(buffer, indent)
	end

	return buffer
end

-- Modifiers
local function modEndLines(text, indent)
	local buffer = {}
	local lastPrev
	for curr=2, #text+1 do
		local prev = prevLine(indent, curr)
		if prev ~= lastPrev then
			table.insert(buffer, text[prev])
		end

		if indent[curr] and (indent[curr] < indent[prev]) then
			if not string.find(text[curr], '^\t*else:$') and
			not string.find(text[curr], '^\t*elseif%s.*:$') then
				endLines(indent[prev], indent[curr], buffer)
			else
				endLines(indent[prev], indent[curr]+1, buffer)
			end
		end

		if curr == #text+1 then
			endLines(indent[prev], 0, buffer)
		end

		if prev == lastPrev then
			table.insert(buffer, '')
		end

		lastPrev = prev
	end

	return buffer
end

local function modMath(text, indent)
	local buffer = {}
	for curr=1, #text do
		local line = text[curr]
		line = line:gsub("([%w_]+)%s([%+%-%*/%%])=", "%1 = %1 %2")
		line = line:gsub("!=", "~=")
		table.insert(buffer, line)
	end

	return buffer
end

local function modStatements(text, indent)
	local buffer = {}

	for curr=1, #text do
		local statement = statementType(text[curr])
		if statement == 'if' then
			local sub = string.gsub(text[curr], ':$', ' then')
			table.insert(buffer, sub)
		elseif (statement == 'for') or (statement == 'while') then
			local sub = string.gsub(text[curr], ':$', ' do')
			table.insert(buffer, sub)
		elseif statement == ('function') or statement == ('else') or statement == ('elseif') then
			local sub = string.gsub(text[curr], ':$', '')
			table.insert(buffer, sub)
		else
			table.insert(buffer, text[curr])
		end
	end

	return buffer
end

local text, output, outputPath, indent = loadFiles(args.input, args.output)
local interpreter = args.interpreter

-- TODO: Check for spaces, and convert to tabs before doing check
local pass, message = checkIndentation(text, indent)

if pass then
	local buffer = compile(text, indent, modEndLines, modMath, modStatements)
	writeOutput(buffer, output)
else
	print(message)
end

if args.output == nil or args.execute == true then
	local pipe = io.popen(args.interpreter.." "..outputPath)
	repeat
		local c = pipe:read(20)
		if c then
			io.write(c)
			io.flush()
		end
	until not c
end
