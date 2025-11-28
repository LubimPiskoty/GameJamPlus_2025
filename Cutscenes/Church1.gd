extends Node

@onready var balloon:= preload("res://Cutscenes/balloon.tscn")
@onready var fightScene := preload("res://Systems/FightSystem/Fight.tscn")

@export var angel_dialog: DialogueResource

var will_fight = false

func _on_angel_area_2d_body_entered(body: Node2D) -> void:
	# Check if body is player!!
	if body.has_meta("player"):
		body.handle_input = false
		var tween = create_tween()
		tween.set_trans(tween.TRANS_EXPO)
		tween.tween_property(%Camera, "zoom", Vector2.ONE * 3, 1)
		await get_tree().create_timer(0.8).timeout
		# and start dialog
		DialogueManager.show_dialogue_balloon_scene(balloon, angel_dialog, "find_angel", [self])
		await DialogueManager.dialogue_ended
		if will_fight:
			will_fight = false
			start_fight()
			return


		tween = create_tween()
		tween.set_trans(tween.TRANS_EXPO)
		tween.tween_property(%Camera, "zoom", Vector2.ONE * 2, 1)
		await get_tree().create_timer(0.8).timeout
		body.handle_input = true

func fight(): #TODO: Refactor later
	will_fight = true

func start_fight():
	get_tree().change_scene_to_packed(fightScene)
