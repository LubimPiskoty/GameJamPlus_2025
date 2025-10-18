extends Node

@onready var keyCombo = $KeyComboUI


func _ready() -> void:
	# For testing try to run key combo on start
	while true:
		var string = ""
		for i in range(8):
			string += String.chr(randi_range(ord("A"), ord("Z")))
		await get_tree().create_timer(1).timeout
		print("Combo score: ", await keyCombo.doCombo(string, 3))
