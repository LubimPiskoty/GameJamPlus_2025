extends CollisionShape2D
@onready var dialogue= preload("res://Dialogue/babka_dialog.dialogue")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		body.handle_input = false
		var tween = create_tween()
		tween.set_trans(tween.TRANS_EXPO)
		tween.tween_property(%Camera, "zoom", Vector2.ONE * 3, 1)
		await get_tree().create_timer(0.8).timeout
		# and start dialog
		DialogueManager.show_example_dialogue_balloon(dialogue, "start",)
		await DialogueManager.dialogue_ended


		tween = create_tween()
		tween.set_trans(tween.TRANS_EXPO)
		tween.tween_property(%Camera, "zoom", Vector2.ONE * 2, 1)
		await get_tree().create_timer(0.8).timeout
		body.handle_input = true
