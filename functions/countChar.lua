return function(input, char)
	local _, count
	if string.find(input, '.') then
		_, count = string.find(input, char)
		if count == nil then count = 0 end
	else
		return nil
	end

	return count
end
