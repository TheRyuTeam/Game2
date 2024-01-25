extends ProgressBar

@export var health_component: HealthComponent

func _ready():
	max_value = health_component.max_hp
	value = health_component.hp
	health_component.connect("hp_changed", Callable(self, "set_hp"))

func set_hp(hp):
	value = hp
