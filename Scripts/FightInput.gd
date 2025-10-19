extends ItemList

@export var fightManger: FightManager

var actionDict: Dictionary[String, Callable] = {"Attack": onAttackAction, "Heal": onHealAction, "Guard": onGuardAction}
@export var attackIcon: Texture2D
@export var healIcon: Texture2D
@export var guardIcon: Texture2D

func _ready() -> void:
	_clear_item_list()

	var iconDict = {"Attack": attackIcon, "Heal": healIcon, "Guard": guardIcon}

	for key in actionDict.keys():
		add_item(key, iconDict.get(key))

func _clear_item_list():
	for i in item_count:
		remove_item(0)

func onAttackAction():
	fightManger.doTurn(FightManager.actionType.ATTACK, true)

func onHealAction():
	fightManger.doTurn(FightManager.actionType.HEAL, true)

func onGuardAction():
	fightManger.doTurn(FightManager.actionType.GUARD, true)


func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var pressed = get_item_text(index)
	print("Pressed: ", pressed)
	if actionDict.has(pressed):
		actionDict.get(pressed).call()
	else:
		printerr("[FightInput] Key not in dictionary")
