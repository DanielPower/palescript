return function(line)
	if line:find('if%s.*:$') then
		return 'if'
	elseif line:find('while%s.*:$') then
		return 'while'
	elseif line:find('for%s.*:$') then
		return 'for'
	elseif line:find('function%s.*:$') then
		return 'function'
	elseif line:find('else:$') then
		return 'else'
	elseif line:find('elseif%s.*:$') then
		return 'elseif'
	elseif line:find('{}:,$') or line:find('{}:$') then
		return 'table'
	end
end
