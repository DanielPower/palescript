#!/bin/lua5.1
-- Setup
-----------------------------
-- Arguments
local argparse = require("argparse")("script", "Palescript Compiler")
argparse:argument("input", "Input file.")
argparse:option("-o --output", "Output file.")
argparse:option("-i --interpreter", "Interpreter to pass output to.", "lua5.1")
argparse:flag("-e --execute", "Run lua output after conversion.")
argparse:flag("-d --debug", "Output debug files")
args = argparse:parse()

-- Functions
local countChar = require('functions/countChar')
local statementType = require('functions/statementType')
local split = require('functions/split')
local compile = require('functions/compile')
local loadFiles = require('functions/loadFiles')
local endLines = require('functions/endlines')
local writeOutput = require('functions/writeOutput')

-- Modules
local modEmpty = require('modfiles/empty')
local modMath = require('modfiles/math')
local modIndent = require('modfiles/indent')
local modStatement = require('modfiles/statement')
local modEndlines = require('modfiles/endlines')
local modComments = require('modfiles/comments')

-- Main Code
---------------------------------------
-- Load input file
local text, output = loadFiles(args.input, args.output)

if text then
	local buffer, err = compile(text, modComments, modEmpty, modIndent, modMath, modEndlines, modStatement)
	if err then
		print("[Error] "..err)
	end

	writeOutput(buffer, output)
else
	print(message)
end

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
