extends HBoxContainer
class_name TurnOrder

var iconPrefab: PackedScene = preload("res://Systems/FightSystem/Prefabs/TurnOrderIcon.tscn")
@export var iconWidth: int = 32

func _ready() -> void:
	clear()

func clear():
	for child in get_children(false):
		remove_child(child)


func create(characters: Array[Character], colors: Array):
	"Adds new characters to turn order"
	for i in range(len(characters)):
		var character = characters[i]
		var color = colors[i]
		var iconHolder: TextureRect = iconPrefab.instantiate()
		iconHolder.find_child("AvatarIcon").texture = character.stats.icon
		var border: TextureRect = iconHolder.find_child("Border")
		border.modulate = color
		add_child(iconHolder)

func remove(amount: int) -> SceneTreeTimer:
	var duration = 1.0
	var org_x = position.x

	var tween := create_tween().set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "position", Vector2(org_x-amount*(4+iconWidth),0), duration)
	tween.tween_callback(func(): on_remove_end(org_x, amount))

	for i in range(amount):
		tween = create_tween().set_trans(Tween.TRANS_EXPO)
		tween.tween_property(get_child(i), "modulate", Color.TRANSPARENT, duration)
	return get_tree().create_timer(duration+0.2)


func on_remove_end(org_x:int, amount: int):
	set_position(Vector2(org_x, 0))
	for i in range(amount):
		remove_child(get_child(0))

