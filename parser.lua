local argparse = require("argparse")("script", "Palescript Parser")
local compile = require('functions/compile')
local loadFiles = require('functions/loadFiles')

-- Modfiles
local modEmpty = require('modfiles/empty')
local modMath = require('modfiles/math')
local modIndent = require('modfiles/indent')
local modStatement = require('modfiles/statement')
local modEndlines = require('modfiles/endlines')
local modComments = require('modfiles/comments')

-- Arguments
argparse:argument("input", "Input file.")
argparse:option("-o --output", "Output file.")
argparse:option("-i --interpreter", "Interpreter to pass output to.", "luajit")
argparse:flag("-e --execute", "Run lua output after conversion.")
argparse:flag("-d --debug", "Output debug files")
args = argparse:parse()

-- Load input file
local text, output = loadFiles(args.input, args.output)

-- Compile the input pale file into a lua file using a series of Modfiles.
local buffer, err = compile(text, modComments, modEmpty, modIndent, modMath, modEndlines, modStatement)

if err then
	print("[Error] "..err)
	return 42
end

-- Write the newly compiled lua code to the output file
for _, line in ipairs(buffer) do
	output:write(line..'\n')
end

-- Execute resulting file using the given Lua interpreter (LuaJIT by default)
if args.output == nil or args.execute == true then
	local outputPath = os.tmpname()
	local pipe = io.popen(args.interpreter.." "..outputPath)
	repeat
		local c = pipe:read(20)
		if c then
			io.write(c)
			io.flush()
		end
	until not c
end
