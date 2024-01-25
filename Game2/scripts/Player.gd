extends CharacterBody2D

const SPEED: float = 400.0
const JUMP_VELOCITY: float = 500.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _flipable: Marker2D = $Flipable
@onready var _sprite: AnimatedSprite2D = $Flipable/Sprite
@onready var _damage_area: Area2D = $Flipable/DamageArea
@onready var _damage_area_collision: CollisionShape2D = $Flipable/DamageArea/Collision

var _is_blocked: bool = false

func on_floor() -> bool:
	return is_on_floor()
	
func on_wall() -> bool:
	return is_on_wall()
	
func in_air() -> bool:
	return !on_floor() and !on_wall()

func is_moving() -> bool:
	return velocity.x != 0
	
func is_standing() -> bool:
	return !is_moving()

var _animations = [[in_air, "fall"], [is_moving, "run"], [is_standing, "idle"]]


func _is_move_in_opposite() -> bool:
	return is_moving() and ((velocity.x > 0) != (_flipable.scale.x > 0))

func _update_velocity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_just_pressed("ui_down"):
			velocity.y += JUMP_VELOCITY
	else:
		if Input.is_action_just_pressed("ui_up"):
			velocity.y -= JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _update_direction() -> void:
	if _is_move_in_opposite():
		_flipable.scale.x *= -1

func _physics_process(delta: float) -> void:
	_update_velocity(delta)
	_update_direction()

	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		_sprite.play("attack")

	if _is_blocked:
		return

	for animation in _animations:
		if animation[0].call():
			_sprite.play(animation[1])

func _on_sprite_animation_changed():
	if _sprite.animation == "attack" or _sprite.animation == "attack_rotate":
		_is_blocked = true
		_damage_area_collision.disabled = false

func _on_sprite_animation_finished():
	if _sprite.animation == "attack" or _sprite.animation == "attack_rotate":
		_is_blocked = false
		_damage_area_collision.disabled = true

func _on_health_damaged():
	_sprite.play("hurt")

func _on_health_killed():
	_sprite.play("death")

func _on_damage_area_area_entered(area):
	if area is HitboxComponent:
		var hitbox: HitboxComponent = area
		var attack: Attack = Attack.new()
		attack.damage = 20
		hitbox.damage(attack)
