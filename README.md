# eso-quest-info
Quest info addon to showcase QuestLib, shows all non-completed quests of your current active zone (map).

![preview](https://i.imgur.com/nbOiRHY.png)

`QuestLib.GetZoneQuests()`
Returns a table of quests based on the current zone.
    
`QuestLib.GetQuestId(quest_entry)`
Returns the quest id of a quest-table entry (use it in pair with GetZoneQuests)

`QuestLib.GetQuestGiverName(quest_entry)`
Returns quest giver name

`QuestLib.GetQuestGiverId(quest_entry)`
Returns quest giver id

`QuestLib.GetQuestGlobalPosition(quest_entry)`
Returns x,y quest world position

`QuestLib.GetQuestName(quest_id)`
Returns the quest name based on the quest id (use it in pair with GetZoneQuests)

`QuestLib.IsQuestComplete(id_or_name,force)`
Returns a boolean telling you if you completed the provided quest, force param on true refreshes the completed cache quests (i'll do this automatic later registering an event on quest completition)

`QuestLib.GetCompletedQuests(force)`
Returns a table of completed quests (table format is t[id] = title or t[title] = id)

# TO-DO
- Remove force params by registering game events (the idea would be to refresh the cache on EVENT_QUEST_COMPLETE event, so just need to register a handler to that...)
- Add more quest info (steps, conditions?)
- Quest tracking (?)
