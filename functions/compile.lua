return function(text, ...)
	local modifiers = {...}
	local buffer = text

	for index, modifier in pairs(modifiers) do
		buffer, err = modifier(buffer)

		if args.debug then
			local file = io.open(args.input..'.'..index..'.log', 'w')
			for _, line in ipairs(buffer) do
				file:write(line..'\n')
			end
		end
		
		if err then
			return buffer, err
		end
	end

	return buffer
end
