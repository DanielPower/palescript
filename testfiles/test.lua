local player = {
	foo = 1,
	bar = 12,
	zoo = {
		far = 25,
		boo = 15,
		am = function(foo, bar)
			foo = bar
			jay = {
				coocoo = function(foo, fart)
					for i=1, #test do
						print("HELLO WORLD")
					end
				end,
				steve = "s.t.e.v.e",
			}
			return foo
		end,
		jk = 5,
	},
}
if something then
	foo = foo % bar
	local displayList = {}
	local displayInfo = sh.split(sh.command("xrandr")())
	for _, line in pairs(displayInfo) do
		if string.find(line, " connected ") then
			local _, _, name = string.find(line, "(%a+%-%d+) ")
			local _, _, width, height, x, y = string.find(line, "(%d+)x(%d+)+(%d+)+(%d+)")
			table.insert(displayList, {name, tonumber(x), tonumber(y), tonumber(width), tonumber(height)})
		elseif foo == bar then
			print("oop")
		end
	end
	return displayList
end
function parser.listSinks()
	local sinkList = {}
	local sinkInfo = sh.split(sh.command("pacmd", "list-sinks")())
	local index, id
	for _, line in pairs(sinkInfo) do
		if string.find(line, "index: ") then
			_, _, index = string.find(line, "index:%s(%d+)")
		end
		if string.find(line, "alsa.id = ") then
			_, _, id = string.find(line, 'alsa.id%s=%s"(.+)"')
		end
		if index and id then
			table.insert(sinkList, {index, id})
			index, id = nil
		end
	end
	return sinkList
end
function parser.listSinkInputs()
	local sinkInputList = {}
	local sinkInputInfo = sh.split(sh.command("pacmd", "list-sink-inputs")())
	for _, line in pairs(sinkInputInfo) do
		if string.find(line, "index: ") then
			_, _, index = string.find(line, "index:%s(%d+)")
			table.insert(sinkInputList, {index})
		end
		if string.find(line, "media.name = ") then
			_, _, media = string.find(line, 'media.name%s=%s"(.+)"')
			sinkInputList[#sinkInputList][2] = media
		end
		if string.find(line, "application.name = ") then
			_, _, application = string.find(line, 'application.name%s=%s"(.+)"')
			sinkInputList[#sinkInputList][3] = application
		end
		if string.find(line, "application.process.id = ") then
			_, _, process = string.find(line, 'application.process.id%s=%s"(.+)"')
			sinkInputList[#sinkInputList][4] = process
		end
		if string.find(line, "application.process.binary = ") then
			_, _, binary = string.find(line, 'application.process.binary%s=%s"(.+)"')
			sinkInputList[#sinkInputList][5] = binary
		end
	end
	return sinkInputList
end
return parser
