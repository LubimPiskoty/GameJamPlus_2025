extends HBoxContainer
class_name TurnOrder

var iconPrefab: PackedScene = preload("res://Systems/FightSystem/Prefabs/TurnOrderIcon.tscn")

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

func remove(amount: int):
	for i in range(amount):
		remove_child(get_child(0))
