-- Test addon just to test the quest api, first use is in line 41
QuestInfo = {}
QuestInfo.GUI = {
	open = false,
	visible = true,
}

function QuestInfo.ModuleInit()
    ml_gui.ui_mgr:AddMember({   id = "ESOMINION##MENU_QUESTER", 
                                name = "QuestInfo", onClick = function() QuestInfo.GUI.open = not QuestInfo.GUI.open end, 
                                tooltip = "Open the QuestInfo addon."},
                                "ESOMINION##MENU_HEADER")
end

function QuestInfo.DrawCall(event, ticks)
    if (QuestInfo.GUI.open) then 
		GUI:SetNextWindowPosCenter(GUI.SetCond_Appearing)
		GUI:SetNextWindowSize(500, 400, GUI.SetCond_FirstUseEver)
		QuestInfo.GUI.visible, QuestInfo.GUI.open = GUI:Begin("QuestInfo", QuestInfo.GUI.open)
		if ( QuestInfo.GUI.visible ) then
            local game_state = GetGameState()
            if ( GUI:TreeNode("Zone Quests") ) then
                if( game_state == 3 ) then
                    local zone_quests = QuestLib.GetZoneQuests()
                    for _, quest in pairs(zone_quests) do
                        local qid = QuestLib.GetQuestId(quest)
                        local qname = QuestLib.GetQuestName(qid)
                        if ( not QuestLib.IsQuestComplete(qid) and GUI:TreeNode(tostring(qid) .. " - " .. qname) ) then
                            GUI:TreePop()
                        end
                    end
                else
                    GUI:Text("Not Ingame...")
                end
                GUI:TreePop()
            end
        end
    end
end

RegisterEventHandler("Module.Initalize", QuestInfo.ModuleInit, "QuestInfo.ModuleInit")
RegisterEventHandler("Gameloop.Draw", QuestInfo.DrawCall, "QuestInfo.DrawCall")
