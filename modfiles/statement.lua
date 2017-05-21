local statementType = require('functions/statementType')

return function(text)
	local buffer = {}

	for index, line in ipairs(text) do
		local statement = statementType(text, index)
		if statement == 'if'
		or statement == 'elseif' then
			local sub = line:gsub(':$', ' then')
			table.insert(buffer, sub)
		elseif (statement == 'for') or (statement == 'while') then
			local sub = line:gsub(':$', ' do')
			table.insert(buffer, sub)
		elseif (statement == 'function')
		or (statement == 'else') then
			local sub = line:gsub(':$', '')
			table.insert(buffer, sub)
		elseif statement == 'table' then
			local sub = line:gsub('{}:', '{')
			local sub = sub:gsub(',$', '')
			table.insert(buffer, sub)
		else
			table.insert(buffer, line)
		end
	end

	return buffer
end
