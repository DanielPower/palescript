return function(line)
	if line:find('^\t*if%s.*:$') then
		return 'if'
	elseif line:find('^\t*while%s.*:$') then
		return 'while'
	elseif line:find('^\t*for%s.*:$') then
		return 'for'
	elseif line:find('^\t*function%s.*:$')
	or line:find('^\t*.*=%s*function%s*(.*):$') then
		return 'function'
	elseif line:find('^\t*else:$') then
		return 'else'
	elseif line:find('^\t*elseif%s.*:$') then
		return 'elseif'
	elseif line:find('{}:,$') or line:find('{}:$') then
		return 'table'
	elseif line:find('^\t*return%s.*$') then
		return 'return'
	end
end
