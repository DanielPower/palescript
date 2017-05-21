local split = require('functions/split')

return function(inputPath, outputPath)
	local input = io.open(inputPath, 'r')
	local text = split(input:read('*all'), '\n')

	local output
	if not outputPath then
		outputPath = os.tmpname()
	end

	output = io.open(outputPath, 'w')

	return text, output
end
