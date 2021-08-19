local utils = _G["QuestLibUtils"]
local internal = _G["QuestLibInternal"]

utils.measurements = {}

utils.quest_index  = {
    local_x = 1, 
    local_y = 2, 
    global_x = 3, 
    global_y = 4, 
    quest_id = 5,
    quest_giver = 6
}

utils.quest_data_index                             = {
    quest_type = 1, -- MAIN_STORY, DUNGEON << -1 = Undefined >>
    quest_repeat = 2, -- quest_repeat_daily, quest_repeat_not_repeatable = 0, quest_repeat_repeatable << -1 = Undefined >>
    game_api = 3, -- 100003 means unverified, 100030 or higher means recent quest data
    quest_line = 4, -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
    quest_number = 5, -- Quest Number In QuestLine (10000 = not assigned/not verified)
    quest_series = 6, -- None = 0,    Cadwell's Almanac = 1,    Undaunted = 2, AD = 3, DC = 4, EP = 5.
}

utils.quest_series_type = {
	quest_type_none = 0,
	quest_type_cadwell = 1,
	quest_type_undaunted = 2,
	quest_type_ad = 3,
	quest_type_dc = 4,
	quest_type_ep = 5,
	quest_type_guild_mage = 6,
	quest_type_guild_fighter = 7,
	quest_type_guild_psijic = 8,
	quest_type_guild_thief = 9,
	quest_type_guild_dark = 10,
  }

internal.quest_guild_rank_data = {
    [utils.quest_series_type.quest_type_undaunted] = { name = "", rank = 0, },
    [utils.quest_series_type.quest_type_guild_mage] = { name = "", rank = 0, },
    [utils.quest_series_type.quest_type_guild_fighter] = { name = "", rank = 0, },
    [utils.quest_series_type.quest_type_guild_psijic] = { name = "", rank = 0, },
    [utils.quest_series_type.quest_type_guild_thief] = { name = "", rank = 0, },
    [utils.quest_series_type.quest_type_guild_dark] = { name = "", rank = 0, },
}


local function TextureSplit(inputstr)
    local t = {}
    for str in string.gmatch(inputstr, "([^%/]+)") do
        table.insert(t, str)
    end
    return t
end

function utils:GetZoneAndSubzone(alternative, bStripUIMap, bKeepMapNum)
    local mapTexture = string.lower(e("GetMapTileTexture()"))
    mapTexture = mapTexture:gsub("^.*/maps/", "")
    if bStripUIMap == true then
        mapTexture = mapTexture:gsub("ui_map_", "")
    end
    mapTexture = mapTexture:gsub("%.dds$", "")
    if not bKeepMapNum then
        mapTexture = mapTexture:gsub("%d*$", "")
        mapTexture = mapTexture:gsub("_+$", "")
    end

    if alternative then
        return mapTexture
    end

    return unpack(TextureSplit(mapTexture))
end

function utils:GetQuestName(id)
    return internal.quest_names[id] or "unknown"
end

function IsTableEmpty(table)
    return not table or next(table) == nil
end

function utils:IsEmptyOrNil(t)
    if t == nil or t == "" then return true end
    return type(t) == "table" and IsTableEmpty(t) or false
end

function utils:DeepTableCopy(source, dest)
    dest = dest or {}
     setmetatable (dest, getmetatable(source))
    
    for k, v in pairs(source) do
        if type(v) == "table" then
            dest[k] = utils:DeepTableCopy(v)
        else
            dest[k] = v
        end
    end
    
    return dest
end


function utils:GetZoneMeasurement()
    local zone = e("GetPlayerActiveZoneName()")
	if utils.measurements[zone] then
        return utils.measurements[zone][1], utils.measurements[zone][2], utils.measurements[zone][3]
    end
	e("SetMapToMapListIndex(1)")
	local centerX, _, centerY = e("GuiRender3DPositionToWorldPosition(0,0,0)")
    local stepX = centerX - 125000
    local stepY = centerY - 125000
	local success = e("SetPlayerWaypointByWorldLocation(" .. tostring(stepX) .. ",0," .. tostring(stepY) .. ")")
	if success then
		local firstX, firstY = e("GetMapPlayerWaypoint()")
        local step2X = centerX + 125000
        local step2Y = centerY + 125000
		success = e("SetPlayerWaypointByWorldLocation(" .. tostring(step2X) .. ",0," .. tostring(step2Y) .. ")")
		if success then
			local secondX, secondY = e("GetMapPlayerWaypoint()")
			if firstX ~= secondX and firstY ~= secondY then
				local currentGlobalToWorldFactor = 2 * 2500 / (secondX - firstX + secondY - firstY)
				local currentOriginGlobalX = (firstX + secondX) * 0.5 - centerX * 0.01 / currentGlobalToWorldFactor
				local currentOriginGlobalY = (firstY + secondY) * 0.5 - centerY * 0.01 / currentGlobalToWorldFactor
                utils.measurements[zone] = {currentGlobalToWorldFactor, currentOriginGlobalX, currentOriginGlobalY}
                return currentGlobalToWorldFactor, currentOriginGlobalX, currentOriginGlobalY
			end
		end
	end
end


function utils:GlobalToWorld(globalX, globalY)
    local globalToWorldFactor, originGlobalX, originGlobalY = utils:GetZoneMeasurement()
	local worldX = (globalX - originGlobalX) * globalToWorldFactor
	local worldZ = (globalY - originGlobalY) * globalToWorldFactor
	return worldX, worldZ
end