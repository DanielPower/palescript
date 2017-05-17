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



--[[
return function(text)
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

local indent = {}
for i, line in pairs(text) do
	indent[i] = countChar(line, '^\t+')
end
--]]
