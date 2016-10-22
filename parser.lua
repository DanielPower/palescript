#!/bin/lua5.1

local function countIndents(line)
	if not string.find(line, '.') then
		return nil
	end
	local _, count = string.find(line, '\t+')
	if count == nil then count = 0 end
	return count
end

local function isStatement(line)
	if string.find(line, '.* do$')
	or string.find(line, '.* then$')
	or string.find(line, 'function[%s]?%b()$')
	or string.find(line, '^function%s.+%)$') then
		return(true)
	end
end

local function split(str, pat)
	local t = {}  -- NOTE: use {n = 0} in Lua-5.0
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

local function endLines(start, finish)
	output = ""
	for i=start, finish+1, -1 do
		for j=i-1, 1, -1 do
			output = output..'\t'
		end
		output = output..'end\n'
	end

	return output
end

local input = io.open(arg[1], 'r')
local output = io.open(arg[2], 'w')

local text = split(input:read('*all'), '\n')
local indent = {}
for i, line in pairs(text) do
	indent[i] = countIndents(line)

	print(i, isStatement(line))
end

for curr=1, #text do
	local prev
	local blankLines = 0
	for i=curr-1, 1, -1 do
		if indent[i] ~= nil then
			prev = i
			break
		else
			blankLines = blankLines + 1
		end
	end

	if indent[curr] == nil then
		--output:write('\n')
	else
		if text[prev] then
			output:write(text[prev]..'\n')
			print(prev, curr)
			if isStatement(text[prev]) then
				if indent[curr] ~= indent[prev]+1 then
					error("Incorrect indentation at "..curr)
				end
			else
				if indent[curr] > indent[prev] then
					error("Incorrect indentation at "..curr)
				elseif indent[curr] < indent[prev] then
					output:write(endLines(indent[prev], indent[curr]))
				end
			end
		end
	end

	for i=1, blankLines do
		output:write('\n')
	end
end
