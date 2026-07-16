local fs = require("@lune/fs")
local process = require("@lune/process")
local BuildCodegen = require("./build/modules/BuildCodegen")

local FilePath = "dist/main.lua"
local TempFile = "dist/temp.lua"
local Header = fs.readFile("build/header.luau")

local function minify(text)
	fs.writeFile(TempFile, text)
	-- Skip darklua minification in lune script to prevent process.spawn nil issues, we will run it via shell instead
	return text
end

local Module = fs.readFile("dist/main.rbxm")
local ModelCodegen = BuildCodegen(Module, false)

fs.writeFile(FilePath, Header .. "\n" .. minify(ModelCodegen))