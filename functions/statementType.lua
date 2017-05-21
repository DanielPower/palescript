local function statementType(string)
	if string:find('^\t*if%s') then
		return 'if'
	elseif string:find('^\t*while%s') then
		return 'while'
	elseif string:find('^\t*for%s') then
		return 'for'
	elseif string:find('^\t*function%s+.*:$')
	or string:find('^\t*.*=%s*function%s*(.*):$') then
		return 'function'
	elseif string:find('^\t*else:$') then
		return 'else'
	elseif string:find('^\t*elseif%s') then
		return 'elseif'
	elseif string:find('{}:,$') or string:find('{}:$') then
		return 'table'
	elseif string:find('^\t*return%s') then
		return 'return'
	elseif string:find('^\t*and%s') then
		return 'and'
	elseif string:find('^\t*or%s') then
		return 'or'
	end
end

return function(text, line)
	if text[line]:find(':$') then
		local i = 0
		while true do
			local type = statementType(text[line-i])
			if type ~= 'and' and type ~= 'or'
			and type ~= nil then
				print(type, text[line])
				return type
			else
				i = i + 1
			end
		end
	end
end
