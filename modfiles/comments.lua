return function(text, indent)
	local buffer = {}

	for _, line in ipairs(text) do
		local startComment = line:find("%-%-")
		if startComment then
			line = line:sub(1, startComment-1)
		end
		table.insert(buffer, line)
	end

	return buffer
end
