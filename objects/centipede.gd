class_name Centipede
extends AnimatableBody2D

var started = false
var resetting = false
var spawn_position = Vector2(0,0)
var active = false
var velocity = Vector2(0,0)
var direction = 1
var in_fan = {}

const SPEED = 50.0
const GRAVITY = 200.0
const FAN_STRENGTH = 350.0

func _ready():
	spawn_position = global_position
	if $AnimatedSprite2D.flip_h:
		direction = -1

func _physics_process(delta: float) -> void:
	var active_fans = []
	for fan in in_fan.keys():
		if fan.active_timer > 0.0:
			active_fans.append(fan)
	if started:
		if not active and len(active_fans) == 0:
			velocity += Vector2(0, delta*GRAVITY)
		if len(active_fans) > 0:
			velocity -= Vector2(0, delta*FAN_STRENGTH)
			print(velocity)
		if active:
			velocity.x = direction*SPEED
		var collision = move_and_collide(velocity*delta)
		if collision and (collision.get_collider() != G.player or velocity.y > 0):
			reset()

func reset():
	resetting = true
	$CollisionShape2D.disabled = true
	started = false
	deactivate()
	$AnimationPlayer.play("fade_out")


func _process(delta: float) -> void:
	if not active and is_activated():
		activate()
	if active and not is_activated():
		deactivate()

func activate():
	velocity = Vector2(0,0)
	if not started:
		started = true
	active = true
	$AnimatedSprite2D.play("active")

func deactivate():
	velocity = Vector2(0,0)
	active = false
	$AnimatedSprite2D.play("idle")

func is_activated():
	if G.player.hourglass_active and not resetting:
		return $CollisionShape2D.shape.collide(
			$CollisionShape2D.global_transform,
			G.player.get_node("HourglassEffect/Collision").shape,
			G.player.get_node("HourglassEffect/Collision").global_transform
		)
	else:
		return false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		global_position = spawn_position
		$AnimationPlayer.play("fade_in")
	if anim_name == "fade_in":
		$CollisionShape2D.disabled = false
		resetting = false
