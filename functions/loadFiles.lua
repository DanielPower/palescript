local split = require('functions/split')
local countChar = require('functions/countChar')

return function(inputPath, outputPath)
	local input = io.open(inputPath, 'r')
	local text = split(input:read('*all'), '\n')

	local output
	if outputPath then
		output = io.open(outputPath, 'w')
	else
		outputPath = os.tmpname()
		output = io.open(outputPath, 'w')
	end

	local indent = {}
	for i, line in pairs(text) do
		indent[i] = countChar(line, '^\t+')
	end

	return text, output, indent
end
