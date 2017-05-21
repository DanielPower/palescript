#!/bin/lua5.1
-- Setup
-----------------------------
-- Arguments
local argparse = require("argparse")("script", "Palescript Compiler")
argparse:argument("input", "Input files."):args("+")
argparse:argument("output", "Output directory")
args = argparse:parse()

-- Functions

-- Main Code
-----------------------------
