return function(text, output)
	for _, line in pairs(text) do
		output:write(line..'\n')
	end
end
