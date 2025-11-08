extends CanvasLayer

@onready var fightMenu: FightMenu = $FightUI/DialogPanel
@onready var turnOrderHolder: HBoxContainer = $FightUI/TurnOrder/IconHolder

var turnOrder = []

func _ready() -> void:
	print("Starting")
	await fightMenu.DoDialog("A wild cigan has appeared!!")
	print("Showing turn")
	fightMenu.DoTurn(["Peter", "Jano"])



