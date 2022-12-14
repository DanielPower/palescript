return function(text)
	local buffer = {}

	for _, line in ipairs(text) do
		if line:find("[^%s]") then
			table.insert(buffer, line)
		end
	end

	return buffer
end
