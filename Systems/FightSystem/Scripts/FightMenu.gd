extends Control 
class_name FightMenu

# Horrible code dont even look at it
# List out the characters and their stats, abilities
# And selects the ability

@onready var menuHolder: Control = $FightMenu
@onready var charMenu: KeyMenu = $FightMenu/Characters
@onready var ablMenu: KeyMenu = $FightMenu/Abilities
@onready var enmMenu: KeyMenu = $EnemySelector
var dialogBalloon = preload("res://Systems/FightSystem/Prefabs/balloon.tscn")


func DoTurn(characters: Array[Character], active: Array[Character]):
	menuHolder.visible = true
	while len(active):
		charMenu.update_all(characters, active)
		charMenu.set_process_input(true)
		var source = await charMenu._on_selected
		var ability = await ablMenu._on_selected
		var target = await enmMenu._on_selected

		#TODO: Make target selection based on the ability params

		var text = ability.use(source, target)
		await DoDialog(text, true)

		active.pop_at(active.find(source))

func DoDialog(string: String, showMenu: bool = false):
	menuHolder.visible = false
	DialogueManager.show_dialogue_balloon_scene(dialogBalloon, DialogueManager.create_resource_from_text(string))
	await DialogueManager.dialogue_ended
	if showMenu:
		menuHolder.visible = true
