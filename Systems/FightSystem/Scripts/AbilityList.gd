extends KeyMenu

@onready var inspector: ItemList = %Inspector

func add(item: Variant):
	var ability: AbilityStats = item
	add_item(ability.name, ability.icon)

func update_inspector(item: Variant):
	inspector.clear()

	var ability: AbilityStats = item
	inspector.add_item("DMG: %d" % [ability.damage])
	var dmg_type = ["Pierce", "Slash", "Blunt"][ability.damage_type]
	inspector.add_item("TYPE: %s" % [dmg_type])
