extends CanvasLayer

@onready var fightMenu: FightMenu = $FightUI/DialogPanel
@onready var turnOrderHolder: TurnOrder = $FightUI/TurnOrder/IconHolder

@export var characters: Array[Character]
var turnQueue: Array[Character] = []

func _ready() -> void:
	for c in characters:
		c.handle_input = false
		c._on_death.connect(on_death)

	if not len(characters):
		printerr("Characters array is empty!!")

	# Create turnQueue
	for i in range(128):
		turnQueue.append(characters[i % len(characters)])

	turnOrderHolder.create(turnQueue)
	startFight.call_deferred()

func startFight():
	while true:
		var onTurn: Array[Character] = get_consecutive()
		if not onTurn[0] is Enemy:
			await fightMenu.DoTurn(get_friendly(), onTurn.duplicate(), characters)
		else:
			for enemy in onTurn:
				await fightMenu.DoDialog(enemy.stats.name + " has skipped it's turn")
		turnOrderHolder.remove_from_front(onTurn)

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
	


#TODO: Make turn order UI updater
#TODO: Make AI
#TODO: Make damage!


	
	
