extends Resource
class_name CharacterStats

@export var name: String = "Character"
@export var icon: Texture2D

@export var max_health = 10
@export var speed = 10
@export var max_armor = 5
@export var armorReduction = 4

var health = 0
var armor = 0
#TODO make modifiers

func _init() -> void:
	health = max_health
	armor = max_armor

func applyDamage(amount: int, armor_multiplier: int = 1):
	"Applies armor reduction to the damage. Armor armor_multiplier changes the damage absorbed by armor"
	changeArmor(amount * armor_multiplier)
	if armor:
		amount -= armorReduction
	changeHealth(amount)


func changeHealth(amount: int):
	"Changes health applies clamping"
	health = clampi(health + amount, 0, max_health)


func changeArmor(amount: int):
	"Changes armor applies clamping"
	armor = clampi(armor + amount, 0, max_armor)

