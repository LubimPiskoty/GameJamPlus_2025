extends Resource
class_name AbilityStats

enum DMG_TYPE {PIERCE, SLASH, BLUNT}

@export var name: String = "BASE"
@export var icon: Texture2D 
@export var damage: int = 0
@export var damage_type: DMG_TYPE = DMG_TYPE.SLASH

func use(source: Character, target: Character) -> String:
	# Simply deal damage
	target.stats.applyDamage(damage, damage_type)
	if target.stats.health == 0:
		return target.stats.name + " has perished"
	return source.stats.name + " is using ability " + name + " on " + target.stats.name
