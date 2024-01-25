extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var _flipable: Marker2D = $Flipable
@onready var _sprite: AnimatedSprite2D = $Flipable/Sprite

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	_sprite.play("idle_front")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func _on_health_component_killed():
	queue_free()
