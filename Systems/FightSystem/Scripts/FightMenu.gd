extends Control 
class_name FightMenu

# List out the characters and their stats, abilities
# And selects the ability

@onready var menuHolder: Control = $FightMenu
@onready var charactersList: ItemList = $FightMenu/Characters
@onready var abilitiesList: ItemList = $FightMenu/Abilities
@onready var statsList: ItemList = $FightMenu/Stats

@onready var dialog: FightBalloonScript = $FightBalloon

var selected: ItemList = null

# TODO: Create character, stats, abilities class for this use
func DoTurn(characters: Array[String]):
	menuHolder.visible = true

	charactersList.clear()
	abilitiesList.clear()

	for character in characters:
		charactersList.add_item(character)

	for a in ["Slash", "Bite"]:
		abilitiesList.add_item(a)

	selected = charactersList
	charactersList.select(0)
	inspect(charactersList.get_item_text(0))
	

func DoDialog(string: String):
	menuHolder.visible = false
	dialog.start(DialogueManager.create_resource_from_text(string), "")
	await DialogueManager.dialogue_ended

func _input(event: InputEvent) -> void:
	if selected == null:
		return

	var fields = [charactersList, abilitiesList]
	var i = fields.find(selected)
	if event.is_action_pressed("ui_left"):
		if i-1 >= 0:
			selected.deselect_all()
			selected = fields[i-1]
			selected.select(0)
			inspect(selected.get_item_text(0))

	if event.is_action_pressed("ui_right"):
		if i+1 < fields.size():
			selected = fields[i+1]
			selected.select(0)
			inspect(selected.get_item_text(0))

	if event.is_action_pressed("ui_up"):
		i = selected.get_selected_items()[0]
		if i-1 >= 0:
			selected.deselect_all()
			selected.select(i-1)
			inspect(selected.get_item_text(i-1))

	if event.is_action_pressed("ui_down"):
		i = selected.get_selected_items()[0]
		if i+1 < selected.item_count:
			selected.deselect_all()
			selected.select(i+1)
			inspect(selected.get_item_text(i+1))


func inspect(string: String):
	statsList.clear()

	if string == "Peter":
		statsList.add_item("HP: 30")
		statsList.add_item("Speed: 10")
		statsList.add_item("Armor: 50")

	elif string == "Jano":
		statsList.add_item("HP: 15")
		statsList.add_item("Speed: 50")
		statsList.add_item("Armor: 10")
	
	elif string == "Slash":
		statsList.add_item("TYPE: Slashing")
		statsList.add_item("DMG: 5")
		statsList.add_item("RNG: 1")

	elif string == "Bite":
		statsList.add_item("TYPE: Piercing")
		statsList.add_item("DMG: 8")
		statsList.add_item("RNG: 1")
