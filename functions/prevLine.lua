return function(indent, line)
	local prev
	local blankLines = 0
	for i=line-1, 1, -1 do
		if indent[i] ~= nil then
			prev = i
			break
		else
			blankLines = blankLines + 1
		end
	end

	return prev, blankLines
end
