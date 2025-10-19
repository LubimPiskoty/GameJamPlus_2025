class_name FightManager
extends CanvasLayer

@export var keyCombo: KeyCombo
@export var dialog: Label

@export var playerHealth: Label
@export var playerAtack: Label
@export var playerDefense: Label

@export var comboTimeout: float = 1

enum actionType {ATTACK, HEAL, GUARD}

class FightData:
	var health: int
	var maxHealth: int
	var damage: int
	var defense: int
	var defenseModifier: int

	func _init(_health, _maxHealth, _damage, _defense) -> void:
		health = _health
		maxHealth = _maxHealth
		damage = _damage
		defense = _defense
		defenseModifier = 0

var isRunning: bool = false
var turn: int = 0 # Player is even numbers
var turnOrder: Array[FightData] = []
var winCallback: Callable
var loseCallback: Callable

func startFight(player: FightData, enemy: FightData, win: Callable = defaultWin, lose: Callable = defaultLose):
	winCallback = win
	loseCallback = lose
	self.visible = true

	turnOrder.clear()
	turnOrder.append(player)
	turnOrder.append(enemy)
	turn = 0
	isRunning = true

	playerHealth.text = str(turnOrder[0].health)
	playerAtack.text = str(turnOrder[0].damage)
	playerDefense.text = str(turnOrder[0].defense)
	dialog.text = "Player is on turn"


func doTurn(action: actionType, isPlayer: bool = false):
	print("Trying to do turn: ", turn, " by ", "Player" if isPlayer else "Enemy")
	if (turn % 2 != (0 if isPlayer else 1)) or not isRunning:
		return

	if not isPlayer:
		await get_tree().create_timer(1).timeout
	dialog.text = ("Player" if isPlayer else "Enemy") + " is taking turn doing " + actionType.keys()[action]
	await get_tree().create_timer(1).timeout

	var doerIndex = 0 if isPlayer else 1
	var doer = getOpponent(doerIndex+1)
	var opponent = getOpponent(doerIndex)
	doer.defenseModifier = 0

	match action:
		actionType.ATTACK:
			var damage = 0
			if isPlayer:
				damage = await keyCombo.doComboLength(doer.damage, comboTimeout) - (opponent.defense + opponent.defenseModifier)
			else:
				damage = doer.damage - await keyCombo.doComboLength(opponent.defense + opponent.defenseModifier, comboTimeout)
			opponent.health -= max(damage, 0)
			if opponent.health < 0:
				# Trigger death
				if isPlayer:
					winCallback.call()
				else:
					loseCallback.call()

		actionType.HEAL:
			doer.health = min(doer.health + await keyCombo.doComboLength(doer.defense, comboTimeout), doer.maxHealth)
		actionType.GUARD:
			doer.defenseModifier += 2

	# Update UI
	playerHealth.text = str(max(turnOrder[0].health, 0))

	await get_tree().create_timer(1).timeout
	turn += 1
	if isPlayer: # Do AI turn
		doTurn(actionType.ATTACK)
	else:
		dialog.text = "Player is on turn"
			
func getOpponent(doerIndex: int) -> FightData:
	return turnOrder[(doerIndex + 1) % turnOrder.size()]

func defaultWin():
	isRunning = false
	dialog.text = "Player has WON!!"

func defaultLose():
	isRunning = false
	dialog.text = "Player has LOST!!"
	
