-- Obtained from https://github.com/premek/pink/tree/b6492993650aeccd4c79f0e10c0d95df056cae46
-- with minor edits to parser.lua and runtime.lua
-- Trimmed for only the essentials
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local import = require(ReplicatedStorage.Packages.Import)

-- import these with require to preserve intellisense
local parser = require(script.Parent.parser)
local runtime = require(script.Parent.runtime)

-- TODO: Test this function for ink files with INCLUDE
local function basedir(str)
	return str:gsub("(.*)(/.*)", "%1")
end

-- pink uses lua io reader to obtain contents. To preserve some of the behavior from this, we use vocksel's import module
-- which supports string imports.
local parse
parse = function(file: string, debug)
	local parsed = {}
	local str = import(file)
	if not str:IsA("StringValue") then
		error(`expected StringValue instance; got {str.ClassName}`)
	end
	for _, t in ipairs(parser(str.Value, file, debug)) do
		if t[2] and t[1] == "include" then
			for _, includedNode in ipairs(parse(basedir(file) .. "/" .. t[2])) do
				table.insert(parsed, includedNode)
			end
		else
			table.insert(parsed, t)
		end
	end
	return parsed
end

local function getStory(filename, debug)
	return runtime(parse(filename, debug), debug)
end

return getStory
