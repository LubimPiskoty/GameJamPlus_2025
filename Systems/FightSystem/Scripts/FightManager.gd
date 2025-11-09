extends CanvasLayer

@onready var fightMenu: FightMenu = $FightUI/DialogPanel
@onready var turnOrderHolder: TurnOrder = $FightUI/TurnOrder/IconHolder

@export var frienlyColor: Color = Color.GREEN_YELLOW
@export var enemyColor: Color = Color.ORANGE_RED

@export var friendly: Array[Character]
@export var enemies: Array[Character]
var turnOrder: Array[Character] = []

func _ready() -> void:
	if not len(friendly) or not len(enemies):
		printerr("Friendly or Enemies array is empty!!")
	for i in range(32):
		turnOrder.append_array(friendly if i%2 else enemies)
	
	turnOrderHolder.create(turnOrder, turnOrder.map(func(x) -> Color: return frienlyColor if x in friendly else enemyColor))

	var timer: SceneTreeTimer = null
	while true:
		var onTurn: Array[Character] = get_consecutive()
		if onTurn[0] in friendly:
			fightMenu.enmMenu.update(enemies, false, false)
			await fightMenu.DoTurn(friendly, onTurn.duplicate())
		else:
			for enemy in onTurn:
				await fightMenu.DoDialog(enemy.stats.name + " has skipped it's turn")
		if timer and timer.time_left > 0:
			print("TOO FAST")
			await timer.timeout
		timer = turnOrderHolder.remove(len(onTurn))

func get_consecutive() -> Array[Character]:
	var consecutive: Array[Character] = [turnOrder.pop_front()]
	var team = friendly if consecutive[0] in friendly else enemies
	while turnOrder[0] in team:
		consecutive.append(turnOrder.pop_front())
	return consecutive

		


#TODO: Make turn order UI updater
#TODO: Make AI
#TODO: Make damage!


	
	
