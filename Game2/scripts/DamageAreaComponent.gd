extends Area2D
class_name DamageAreaComponent

func _on_area_entered(area):
	print("attacked ")
	if area is HitboxComponent:
		print("attacked ")
		var hitbox: HitboxComponent = area
		var attack: Attack = Attack.new()
		attack.damage = 20
		hitbox.damage(attack)
