extends KeyMenu

@onready var inspector: ItemList = %Inspector
var highlighted_enemy: Character

func add(item: Variant):
	var enemy: Character = item
	add_item(enemy.stats.name)

func update_inspector(item: Variant):
	inspector.clear()
	if highlighted_enemy:
		highlighted_enemy.dehighlight()

	var enemy: Character = item
	var enemyStats: CharacterStats = enemy.stats
	inspector.add_item("%s" % [enemyStats.name])
	inspector.add_item("HP: %d/%d" % [enemyStats.health, enemyStats.max_health])
	inspector.add_item("ARMOR: %d/%d" % [enemyStats.armor, enemyStats.max_armor])
	# inspector.add_item("DEFENSE: %d" % [enemyStats.armorReduction])
	inspector.add_item("SPEED: %d" % [enemyStats.speed])
	
	highlighted_enemy = enemy
	enemy.highlight(Color.RED)

func changeMenu(selected: Variant):
	highlighted_enemy.dehighlight()
	super.changeMenu(selected)
	
