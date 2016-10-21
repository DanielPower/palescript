#!/bin/lua5.1

local function countIndents(line)
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

local input = io.open(arg[1], 'r')
local output = io.open(arg[2], 'w')
local code = input:read('*all')

local lines = {}
for line in string.gmatch(code, "[^\n]+") do
	table.insert(lines, {text=line})
end

for i, line in pairs(lines) do
	if lines[i-1] then prev = lines[i-1] end
	line.indent = countIndents(line.text)

	if prev then
		if isStatement(prev.text) then
			if line.indent < (prev.indent + 1) then
				error("Indentation expected at line "..i)
			elseif line.indent > (prev.indent + 1) then
				error("Unexpected indentation at line "..i)
			else
				output:write(prev.text..'\n')
			end
		else
			if line.indent > prev.indent then
				error("Unexpected indentation at line "..i)
			elseif line.indent == prev.indent then
				output:write(prev.text..'\n')
			else
				output:write(prev.text..'\n')
				for i=prev.indent-1, line.indent, -1 do
					for j=i, 1, -1 do
						output:write('\t')
					end
					output:write('end\n')
				end
			end
		end
	end
end
