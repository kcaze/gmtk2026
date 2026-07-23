extends AnimatableBody2D

@export var SPEED = 50.0
var time_advanced = 0.0
var start_position = Vector2(0,0)
var forwards_dir = true

func _ready():
	start_position = global_position

func _physics_process(delta: float) -> void:
	if is_activated():
		time_advanced += delta
	var path_length = $Path2D.curve.get_baked_length()
	var dist_traveled = fmod(time_advanced * SPEED, 2*path_length)
	if dist_traveled > path_length:
		dist_traveled = 2*path_length - dist_traveled
	$Path2D/PathFollow2D.progress = dist_traveled
	var dest = start_position + $Path2D/PathFollow2D.position 
	global_position = dest

func is_activated():
	return $CollisionShape2D.shape.collide(
		$CollisionShape2D.global_transform,
		G.player.get_node("HourglassEffectCollision").shape,
		G.player.get_node("HourglassEffectCollision").global_transform
	)
