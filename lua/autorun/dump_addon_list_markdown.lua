local fEngineGetAddons = engine.GetAddons
local fFileWrite = file.Write
local fOsDate = os.date
local fStringFormat = string.format
local fStringNiceSize = string.NiceSize
local fTableConcat = table.concat
local fTableInsert = table.insert
local SysTime = SysTime
local tobool = tobool

local sYes = "✔"
local sNo = "❌"
local sFileName = "addon_list.md.txt"
local sMainTitle = "# Addon list\n\n"
local sAddonFormat = [[
## [%s](<https://steamcommunity.com/sharedfiles/filedetails/?id=%s>) %s

Workshop ID: `%s`

Size: %s

Updated: %s

File: `%s`

Downloaded: %s

Mounted: %s

Models: %s
]]
local sDateFormat = "%Y-%m-%d %H:%M:%S"

local function addon(tAddon)
	return fStringFormat(sAddonFormat,
		tAddon.title, tAddon.wsid, tAddon.mounted and "✔" or "❌",
		tAddon.wsid,
		fStringNiceSize(tAddon.size),
		fOsDate(sDateFormat, tAddon.updated),
		tAddon.file ~= "" and tAddon.file or sNo,
		tAddon.downloaded and sYes or sNo,
		tAddon.mounted and sYes or sNo,
		tAddon.models
	)
end

local function dump_addon_list(tArgs)
	local iStartTime = SysTime()
	local tStrings = {}
	local tAddons = fEngineGetAddons()
	local bOnlyMounted = tobool(tArgs[1])

	for _, tAddon in ipairs(tAddons) do
		if bOnlyMounted and not tAddon.mounted then continue end
		fTableInsert(tStrings, addon(tAddon))
	end

	fFileWrite(sFileName, sMainTitle .. fTableConcat(tStrings, "\n"))

	print("Addon list written in Markdown format to data/" .. sFileName)
	print("Took " .. SysTime() - iStartTime .. " seconds.")
end

concommand.Add("dump_addon_list_markdown", function(_, _, tArgs)
	dump_addon_list(tArgs)
end)
