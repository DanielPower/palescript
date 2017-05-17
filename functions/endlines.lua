return function(start, finish, text, buffer)
	for i=start, finish+1, -1 do
		local output = ""
		for j=i-1, 1, -1 do
			output = output..'\t'
		end

		output = output..text
		table.insert(buffer, output)
	end
end
