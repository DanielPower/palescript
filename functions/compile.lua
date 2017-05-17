return function(text, ...)
	local modifiers = {...}
	local buffer = text

	for index, modifier in pairs(modifiers) do
		if args.debug then
			local file = io.open('.'..index..'.log', 'w')
			for _, line in ipairs(buffer) do
				file:write(line..'\n')
			end
		end
		buffer = modifier(buffer)
	end

	return buffer
end