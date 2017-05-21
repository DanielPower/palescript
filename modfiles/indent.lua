local statementType = require('functions/statementType')

return function(text)
	local buffer = {}
	local tabchar = nil
	local tablength = nil

	-- Determine whether the file is using tabs or spaces
	for _, line in ipairs(text) do
		if tabchar == nil then
			-- Check if there is a tab at the beginning of the line
			if line:find('^%t') then
				tabchar = "tab"
				break
			-- Check if there is a space at the beginning of the line
			else
				_, tablength = line:find('^%s+')
				if tablength then
					tabchar = "space"
					break
				end
			end
		end
	end

	if tabchar == "tab" then
		for _, line in ipairs(text) do
			-- Abort if we find space indentation in a file that started with tabs
			if line:find('^%s') then
				local err = "You cannot mix tabs and spaces"
				return _, err
			end
		end
	elseif tabchar == "space" then
		for _, line in ipairs(text) do
			-- Abort if we find tab indentation in a file that started with spaces
			if line:find('^%t') then
				local err = "You cannot mix tabs and spaces"
				return _, err
			end
		end

		for _, line in ipairs(text) do
			local _, indent = line:find("^%s+")
			if indent then
				line = ("\t"):rep(indent/tablength)..line:sub(indent+1)
			end

			table.insert(buffer, line)
		end
	end

	return buffer
end
