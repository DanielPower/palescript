local prevLine = require('functions/prevLine')
local statementType = require('functions/statementType')

return function(text, indent)
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
