extends Node2D
class_name HealthComponent

@export var max_hp: float		= 100
@export var can_heal: bool		= false
@export var can_overheal: bool	= false
@export var invincible: bool	= false
var hp: float

signal max_hp_changed(int)
signal hp_changed(int)
signal can_heal_changed(bool)
signal can_overheal_changed(bool)
signal invincible_changed(bool)
signal damaged
signal healed
signal killed

func _ready() -> void:
	self.hp = self.max_hp

func is_alive() -> bool:
	return hp > 0

func deal_damage(attack: Attack) -> void:
	if attack.damage < 0:
		__heal_impl(attack)
	elif attack.damage > 0:
		__damage_impl(attack)

func __damage_impl(attack: Attack) -> void:
	if !invincible:
		hp = max(0, hp - attack.damage)
		hp_changed.emit(hp)
		if hp != 0:
			damaged.emit()
		else:
			killed.emit()

func __heal_impl(attack: Attack) -> void:
	if can_heal:
		hp -= attack.damage
		if not can_overheal:
			hp = max(max_hp, hp)
		hp_changed.emit(hp)
		healed.emit()
