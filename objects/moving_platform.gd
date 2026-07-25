extends AnimatableBody2D

@export var SPEED = 50.0
var start_position = Vector2(0,0)
var forwards_dir = true
@onready var track : Track = get_parent()

func _ready():
	start_position = global_position
	

func _physics_process(delta: float) -> void:
	var m = ($Sprite2D.material as ShaderMaterial)
	var sat = m.get_shader_parameter("saturation")
	
	if is_activated():
		track.update_progress(delta*SPEED)
		sat = lerpf(sat, 1.0, 0.5)
	else:
		sat = lerpf(sat, 0.0, 0.5)
	m.set_shader_parameter("saturation", sat)
	global_position = track.get_progress_position()

func is_activated():
	return $CollisionShape2D.shape.collide(
		$CollisionShape2D.global_transform,
		G.player.get_node("HourglassEffectCollision").shape,
		G.player.get_node("HourglassEffectCollision").global_transform
	)
