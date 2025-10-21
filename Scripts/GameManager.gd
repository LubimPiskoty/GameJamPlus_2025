extends Node2D

@export var ZeusTeleportToNode: Node2D
@export var fightManager: FightManager
@export var dialogue: DialogueResource
var a = false 
func _on_zeus_dialog_body_entered(body: Node2D) -> void:
	if body.name != "Player" or a :
		return
	a=true
	body.process_mode = Node.PROCESS_MODE_DISABLED
	DialogueManager.show_dialogue_balloon(dialogue, "start")
	await DialogueManager.dialogue_ended
	body.global_position = ZeusTeleportToNode.global_position
	await get_tree().create_timer(0.5).timeout
	body.process_mode = Node.PROCESS_MODE_INHERIT


func _on_monster_fight_1_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	startCombat(body)


func _on_monster_fight_2_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	startCombat(body)

func startCombat(body: Node2D):
	body.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(0.5).timeout

	var player = FightManager.FightData.new(20, 20, 5, 3)
	var enemy = FightManager.FightData.new(10, 10, 6, 2)
	fightManager.startFight(player, enemy)
