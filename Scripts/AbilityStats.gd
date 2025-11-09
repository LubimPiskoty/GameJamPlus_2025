extends Resource
class_name AbilityStats

enum DMG_TYPE {PIERCE, SLASH, BLUNT}

@export var name: String = "ABILITY"
@export var icon: Texture2D 
@export var damage: int = 10
@export var damage_type: DMG_TYPE = DMG_TYPE.SLASH

func useAbility(source: Node, target: Node):
	print_debug(source.name + " is using ability " + self.resource_name + " on " + target.name)
