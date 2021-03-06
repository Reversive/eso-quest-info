QuestLib = {}

QuestLib.completed_quests = {}
QuestLib.ever_cached = false
QuestLib.last_ccq = 0
local utils = {}
local internal = {}

_G["QuestLibUtils"] = utils
_G["QuestLibInternal"] = internal

function QuestLib.TableWipeKeys (tab)
	while true do
		local k = next(tab)
		if not k then break end
		tab[k] = nil
	end
end

function QuestLib.CacheCompletedQuests()
    local id = 0
	local count = 0
    local t = e("GetFrameTimeMilliseconds()")
	if t == QuestLib.last_ccq then
		return QuestLib.completed_quests
	else
		QuestLib.last_ccq = t
	end
    QuestLib.TableWipeKeys(QuestLib.completed_quests)
    repeat
		id = e("GetNextCompletedQuestId(" .. tostring(id) .. ")")
		if id then
			local title = e("GetCompletedQuestInfo(".. tostring(id) .. ")")
			QuestLib.completed_quests[id] = title
			if (QuestLib.completed_quests[title] or title) ~= title then
				title = "DUPE: "..title
			end
			QuestLib.completed_quests[title] = id
		end
		count = count + 1
		if count > 1000000 then
			return false
		end
	until not id
	QuestLib.ever_cached = true
	return QuestLib.completed_quests
end

function QuestLib.GetCompletedQuests(force)
    if not QuestLib.ever_cached or force then 
		QuestLib.CacheCompletedQuests()
	end
    return QuestLib.completed_quests
end

function QuestLib.IsQuestComplete(id,force)
	if not QuestLib.ever_cached or force then
		QuestLib.CacheCompletedQuests()
	end
	return QuestLib.completed_quests[id]
end

function QuestLib.GetQuestName(quest_id)
	return utils:GetQuestName(quest_id)
end

function QuestLib.GetQuestGiverId(quest)
	return quest[utils.quest_index.quest_giver]
end

function QuestLib.GetQuestGiverName(quest)
	local giver = internal.quest_givers[QuestLib.GetQuestGiverId(quest)]
	if not giver then return "Unknown" end
	return giver
end

function QuestLib.GetQuestId(quest)
	return quest[utils.quest_index.quest_id]
end

function QuestLib.GetQuestGlobalPosition(quest)
	return utils:GlobalToWorld(quest[utils.quest_index.global_x],quest[utils.quest_index.global_y])
end

function QuestLib.GetZoneQuests()
	return internal:GetZoneQuests()
end

function QuestLib.GetZoneMeasurement()
	return utils:GetZoneMeasurement()
end
