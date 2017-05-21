local countChar = require('functions/countChar')
local statementType = require('functions/statementType')

return function(text)
	local block = {}
	local indent = {}
	for i, line in ipairs(text) do
		indent[i] = countChar(line, '^\t+')
	end

	for curr=2, #text do
		--local type = statementType(text, curr)
		if type == "table" then
			block[indent[curr]] = "table"
		end

		if block[indent[curr]-1] == "table" then
			text[curr] = text[curr]:gsub("^(\t*)function%s+(.+)%((.*)%):$", "%1%2 = function(%3):")
		end
	end

	return text
end
