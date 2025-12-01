extends CanvasLayer

@onready var fightMenu: FightMenu = $FightUI/DialogPanel
@onready var turnOrderHolder: TurnOrder = $FightUI/TurnOrder/IconHolder

@export var characters: Array[Character]
var turnQueue: Array[Character] = []
var is_running: bool = true

signal _on_turn_end

func _ready() -> void:
	startFight.call_deferred()
	_on_turn_end.connect(on_turn_end)

func startFight():
	if not len(characters):
		printerr("Characters array is empty!!")

	# Create turnQueue
	for i in range(128):
		turnQueue.append(characters[i % len(characters)])

	turnOrderHolder.create(turnQueue)
	for c in characters:
		c.handle_input = false
		c._on_death.connect(on_death)
	while is_running: #TODO: Handle multiple enemies.. will not work with curent is_running
		var onTurn: Array[Character] = get_consecutive()
		if not onTurn[0] is Enemy:
			await fightMenu.DoTurn(get_friendly(), onTurn.duplicate(), characters)
		else:
			for enemy in onTurn:
				#await fightMenu.DoDialog(enemy.stats.name + " has skipped it's turn")
				var player = characters[characters.find_custom(func(x): return x is not Enemy)]
				var text = await enemy.abilities.get(0).use(enemy, player, %KeyCombo)
				await fightMenu.DoDialog(text, true)

		turnOrderHolder.remove_from_front(onTurn)
		_on_turn_end.emit()

func get_friendly() -> Array[Character]:
	var friendly : Array[Character] = []
	for character in characters:
		if not (character as Enemy):
			friendly.append(character)
	return friendly

func get_consecutive() -> Array[Character]:
	assert(len(turnQueue) > 0, "TurnQueue is empty!")
	var consecutive: Array[Character] = [turnQueue.pop_front()]
	var isEnemy : bool = consecutive[0] is Enemy
	while len(turnQueue) and (turnQueue[0] is Enemy) == isEnemy:
		consecutive.append(turnQueue.pop_front())
	return consecutive

		
func on_death(character: Character):
	turnOrderHolder.remove_all(character)

	var idx: int # Clear turnQueue
	while true:
		idx = turnQueue.find(character)
		if idx == -1:
			break
		turnQueue.remove_at(idx)
	
	idx = characters.find(character)
	if idx != -1:
		characters.remove_at(idx)

	
func on_turn_end():
	if characters.all(func(x): return x is Enemy):
		print("FIGHT END ENEMY WON")
		is_running = false
		await fightMenu.DoDialog("The angel has killed Vesper...")
		get_tree().change_scene_to_file("res://Scenes/church.tscn")
	if characters.all(func(x): return x is not Enemy):
		print("FIGHT END PLAYER WON")
		is_running = false
		await fightMenu.DoDialog("Vesper has slain the angel!!") 
		get_tree().change_scene_to_file("res://Scenes/church.tscn")

#TODO: Make turn order UI updater
#TODO: Make AI
#TODO: Make damage!


	
	
