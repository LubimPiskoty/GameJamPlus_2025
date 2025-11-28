extends Resource
class_name AbilityStats

enum DMG_TYPE {PIERCE, SLASH, BLUNT}

@export var name: String = "BASE"
@export var icon: Texture2D 
@export var damage: int = 0
@export var damage_type: DMG_TYPE = DMG_TYPE.SLASH

func use(source: Character, target: Character, combo: KeyCombo) -> String:
	assert(combo)
	# Simply deal damage
	var mod = 0
	if source is Enemy: # Defent
		mod = damage - await combo.doComboString(name.to_lower(), float(len(name))/3)
	else: # Attack
		mod = await combo.doComboString(name.to_lower(), float(len(name))/3)

	target.stats.applyDamage(mod, damage_type)
	if target.stats.health == 0:
		return target.stats.name + " has perished"
	return source.stats.name + " is using ability " + name + " on " + target.stats.name

func targetingFunc(target: Character) -> bool:
	# Has to be enemy
	return target is Enemy
