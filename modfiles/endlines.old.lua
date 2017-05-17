local statementType = require('functions/statementType')
local prevLine = require('functions/prevLine')
local endLines = require('functions/endlines')

return function(text, indent)
	local buffer = {}
	local lastPrev
	local tableChain = {}
	for curr=1, #text do
		local prev
		if curr > 1 then
			prev = prevLine(indent, curr)
		end

		if indent[curr] then
			if statementType(text[curr]) == 'table' then
				table.insert(tableChain, indent[curr])
			end

			if prev then
				if indent[curr] < indent[prev] then
					if #tableChain > 0 then
						for i=#tableChain, 1, -1 do
							if indent[curr] <= tableChain[i] then
								endLines(indent[prev], tableChain[i], '}', buffer)
								tableChain[i] = nil
							else
								break
							end
						end
					else
						endLines(indent[prev], indent[curr], 'end', buffer)
					end
				end
			end
		end

		if prev == lastPrev then
			table.insert(buffer, '')
		else
			local line
			if #tableChain > 0 then
				if statementType(text[curr]) == nil then
					print(text[curr])
					line = string.gsub(text[curr], '^(.+)', '%1,')
				elseif statementType(text[curr]) ~= 'table' then
					error("Statements not allowed in tables")
				end
			else
				line = text[prev]
			end

			table.insert(buffer, line)
		end

		lastPrev = prev

	--[[for curr=2, #text+1 do
		local prev = prevLine(indent, curr)
		if prev ~= lastPrev then
			table.insert(buffer, text[prev])
		end

		if statementType(text[curr]) == 'table' then

		end

		if indent[curr] and (indent[curr] < indent[prev]) then
			if blockType == 'table' then
			endLines, indent[prev], indent[curr]
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
		]]
	end

	return buffer
end
