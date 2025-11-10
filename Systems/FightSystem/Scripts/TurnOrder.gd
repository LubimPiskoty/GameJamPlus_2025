extends Container
class_name TurnOrder

var iconPrefab: PackedScene = preload("res://Systems/FightSystem/Prefabs/TurnOrderIcon.tscn")

@export var iconWidth: int = 32
@export var separation: int = 4
@export var animationDuration: float = 1.0
@export var frienlyColor: Color = Color.GREEN_YELLOW
@export var enemyColor: Color = Color.ORANGE_RED

var cooldown: SceneTreeTimer
var children: Array[Control]

func _ready() -> void:
	clear()
	cooldown = get_tree().create_timer(0)
	children = []

func clear():
	for child in get_children(false):
		remove_child(child)

func _ensure_cooldown(duration: float):
	if cooldown and cooldown.time_left:
		await cooldown.timeout
	cooldown = get_tree().create_timer(duration)

func _get_iid(character: Character) -> String:
	return "%s" % character.get_instance_id()

func _parse_name_iid(name_iid: String) -> int:
	return int(name_iid.split("_")[0])

func _find_character(character: Character) -> int:
	return children.find_custom(func(x): return x and _parse_name_iid(x.name) == character.get_instance_id())

func _get_pos_from(idx: int) -> Vector2:
	return Vector2.RIGHT * idx * (iconWidth + separation) + Vector2.DOWN * iconWidth/4


func create(characters: Array[Character]):
	"Adds new characters to turn order"
	for i in range(len(characters)):
		var character: Character = characters.get(i)
		var color = enemyColor if character is Enemy else frienlyColor

		var iconHolder: TextureRect = iconPrefab.instantiate()
		iconHolder.find_child("AvatarIcon").texture = character.stats.icon
		var border: TextureRect = iconHolder.find_child("Border")
		border.modulate = color

		iconHolder.size = Vector2i.ONE * iconWidth
		iconHolder.position = _get_pos_from(i)
		add_child(iconHolder)
		iconHolder.name = _get_iid(characters[i]) + "_0"

		children.append(iconHolder)

func remove_all(character: Character):
	_ensure_cooldown(animationDuration)
	get_tree().create_timer(animationDuration).timeout.connect(_on_remove_end)

	while true:
		var idx = _find_character(character)
		if idx == -1:
			break
		animate_remove(children[idx])
		children[idx] = null
			


func remove_from_front(characters: Array[Character]):
	_ensure_cooldown(animationDuration)
	get_tree().create_timer(animationDuration).timeout.connect(_on_remove_end)

	for character in characters:
		var front = _find_character(character) 
		if front != -1:
			animate_remove(children[front])
			children[front] = null


func animate_remove(icon: Control):
	var tween := create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(icon, "position", icon.position + Vector2.DOWN * (iconWidth + separation), animationDuration)
	tween.tween_property(icon, "modulate", Color.TRANSPARENT, animationDuration)
	get_tree().create_timer(animationDuration+5).timeout.connect(icon.queue_free)

func _on_remove_end(duration: float = 1.0): # Collapse empty spaces
	_ensure_cooldown(duration)	

	var empty := 0
	for idx in range(len(children)):
		var icon := children[idx]
		if not icon:
			empty += 1
			continue

		var tween := create_tween().set_trans(Tween.TRANS_EXPO)
		tween.tween_property(icon, "position", _get_pos_from(idx-empty), duration)
		children[idx] = null
		children[idx-empty] = icon
	
	# Clean the end of the array
	for idx in range(0, len(children), -1):
		if not children[idx]:
			children.remove_at(idx)
		else:
			break


		

		
