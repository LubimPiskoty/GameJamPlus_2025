extends Resource
class_name CharacterStats

@export var name: String = "Character"
@export var icon: Texture2D

@export var max_health = 10
@export var speed = 10
@export var max_armor = 20
@export var armorReduction = 4

signal _on_death
signal _on_armor_break
signal _on_damage_taken

var health = 0
var armor = 0
#TODO make modifiers

func _init() -> void:
	make_stats.call_deferred()

func make_stats():
	health = max_health
	armor = max_armor

func applyDamage(amount: int, armor_multiplier: int = 1):
	"Applies armor reduction to the damage. Armor armor_multiplier changes the damage absorbed by armor"
	changeArmor(-amount * armor_multiplier)
	var final_amount = amount
	if armor:
		final_amount = max(amount - armorReduction, 0)
	changeHealth(-final_amount)


func changeHealth(amount: int):
	"Changes health applies clamping"
	if amount < 0:
		_on_damage_taken.emit()
	health = clampi(health + amount, 0, max_health)
	if health == 0:
		_on_death.emit()

func changeArmor(amount: int):
	"Changes armor applies clamping"
	if armor and armor + amount <= 0:
		_on_armor_break.emit()

	armor = clampi(armor + amount, 0, max_armor)

