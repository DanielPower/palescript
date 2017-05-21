local countChar = require('functions/countChar')
local statementType = require('functions/statementType')

return function(text)
	local buffer = {}
	local block = {}
	local indent = {}
	for i, line in ipairs(text) do
		indent[i] = countChar(line, '^\t+')
	end

	for curr=1, #text do
		if curr > 1 then
			if indent[curr] < indent[curr-1] then
				local start = indent[curr-1]-1
				local finish
				if statementType(text[curr]) == "else"
				or statementType(text[curr]) == "elseif" then
					finish = indent[curr]+1
				else
					finish = indent[curr]
				end
				for i=start, finish, -1 do
					local str = ""
					for j=1, i do
						str = str.."\t"
					end
					if block[i] == "end" then
						str = str.."end"
					elseif block[i] == "table" then
						if block[i-1] == "table" then
							str = str.."},"
						else
							str = str.."}"
						end
					end
					table.insert(buffer, str)
				end
			end
		end

		local type = statementType(text[curr])
		if type == "if" or type == "for" or type == "function" then
			block[indent[curr]] = "end"
		elseif type == "table" then
			block[indent[curr]] = "table"
		end

		if block[indent[curr]-1] == "table" then
			table.insert(buffer, text[curr]..',')
		else
			table.insert(buffer, text[curr])
		end
	end

	if indent[#text] > 0 then
		for i=indent[#text]-1, 0, -1 do
			local str = ""
			for j=1, i do
				str = str.."\t"
			end
			if block[i] == "end" then
				str = str.."end"
			elseif block[i] == "table" then
				if block[i-1] == "table" then
					str = str.."},"
				else
					str = str.."}"
				end
			end
			table.insert(buffer, str)
		end
	end

	return buffer
end
