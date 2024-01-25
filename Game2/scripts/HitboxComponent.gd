extends Area2D
class_name HitboxComponent

@export var health_component: HealthComponent

func damage(attack: Attack) -> void:
	print("damage")
	if health_component:
		health_component.deal_damage(attack)
