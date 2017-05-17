return function(text)
	local buffer = {}
	for curr=1, #text do
		local line = text[curr]
		line = line:gsub("([%w_]+)%s([%+%-%*/%%])=", "%1 = %1 %2")
		line = line:gsub("!=", "~=")
		table.insert(buffer, line)
	end

	return buffer
end
