extends KeyMenu

@onready var inspector: ItemList = %Inspector
var highlighted_target: Character
var selectedAbility: AbilityStats

func add(item: Variant):
	assert(selectedAbility, "No ability is selected. Cannot target!")
	add_item(item.stats.name, null, selectedAbility.targetingFunc(item))


func update_inspector(item: Variant):
	inspector.clear()
	if highlighted_target:
		highlighted_target.dehighlight()

	var target: Character = item
	var targetStats: CharacterStats = target.stats
	inspector.add_item("%s" % [targetStats.name])
	inspector.add_item("HP: %d/%d" % [targetStats.health, targetStats.max_health])
	inspector.add_item("ARMOR: %d/%d" % [targetStats.armor, targetStats.max_armor])
	inspector.add_item("DEFENSE: %d" % [targetStats.armorReduction])
	inspector.add_item("SPEED: %d" % [targetStats.speed])
	
	highlighted_target = target
	target.highlight(Color.RED)

func changeMenu(selected: Variant):
	highlighted_target.dehighlight()
	super.changeMenu(selected)
	
