return function(text)
	for curr=1, #text do
		text[curr] = text[curr]:gsub("^(\t*)(%s*.+)%s([%+%-%*/%%])=", "%1%2 = %2 %3")
		text[curr] = text[curr]:gsub("!=", "~=")
	end

	return text
end
