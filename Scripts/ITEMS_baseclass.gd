extends Object
class_name Ingame_Item
# Groundwork for all items

# Standard settings
export(bool) var is_unique = false
export(int) var weight = 1
export(int) var value = 1
export(int, "misc", "weapon", "consumable", "quest_item", "tool") var item_type = 0

export(int) var item_ID = 0 # NEEDS TO BE CHANGED for any new item
export(String) var name = "Pencil" # NEEDS TO BE CHANGED for any new item