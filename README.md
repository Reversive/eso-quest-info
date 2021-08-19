# eso-quest-info
Quest info addon to showcase QuestLib

![preview](https://i.imgur.com/QJE76me.png)

`QuestLib.GetZoneQuests()`
Returns a table of quests based on the current zone.
    
`QuestLib.GetQuestId(quest_entry)`
Returns the quest id of a quest-table entry (use it in pair with GetZoneQuests)

`QuestLib.GetQuestName(quest_id)`
Returns the quest name based on the quest id (use it in pair with GetZoneQuests)

`QuestLib.IsQuestComplete(id_or_name,force)`
Returns a boolean telling you if you completed the provided quest, force param on true refreshes the completed cache quests (i'll do this automatic later registering an event on quest completition)

`QuestLib.GetCompletedQuests(force)`
Returns a table of completed quests (table format is t[id] = title or t[title] = id)

# eso-quest-info
- Remove force params by registering game events (just refresh the cache on EVENT_QUEST_COMPLETE event)
- Add more quest info (normalized x/y positions are available in the table but need to find a way to convert them to 3d world pos somehow)
