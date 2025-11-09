extends KeyMenu

@onready var inspector: ItemList = %Inspector
@export var abilityMenu: KeyMenu


var active: Array[Character]

func _ready() -> void:
	super()
	if not abilityMenu:
		printerr("AbilityMenu ref not selected!!")

func add(item: Variant):
	var character: CharacterStats = item.stats
	add_item(character.name, character.icon, item in active)
	set_item_disabled(item_count-1, not item in active)

func update_inspector(item: Variant):
	inspector.clear()

	var character: CharacterStats = item.stats
	inspector.add_item("HP: %d/%d" % [character.health, character.max_health])
	inspector.add_item("ARMOR: %d/%d" % [character.armor, character.max_armor])
	inspector.add_item("DEFENSE: %d" % [character.armorReduction])
	inspector.add_item("SPEED: %d" % [character.speed])

	# Show abilities without selecting one
	abilityMenu.update(item.abilities, false, false)

func update_all(items, _active: Array[Character]):
	active = _active
	update(items)
