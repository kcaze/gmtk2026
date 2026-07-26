extends StaticBody2D

const ACTIVE_COYOTE_TIME = 0.25

var active = false
var active_timer = 0.0
var player_in_fan = false

func _physics_process(delta: float) -> void:
	if active_timer > 0.0 and player_in_fan:
		G.player.in_fans[self] = true
	else:
		if self in G.player.in_fans:
			G.player.in_fans.erase(self)
	
	if active:
		active_timer = ACTIVE_COYOTE_TIME
	else:
		active_timer = max(0.0, active_timer - delta)

func _process(delta: float) -> void:
	if not active and is_activated():
		activate()
	if active and not is_activated():
		deactivate()

func activate():
	active = true
	active_timer = ACTIVE_COYOTE_TIME
	$AnimatedSprite2D.play("active")
	$CPUParticles2D.restart()
	$CPUParticles2D.emitting = true

func deactivate():
	active = false
	$AnimatedSprite2D.play("idle")
	$CPUParticles2D.emitting = false

func is_activated():
	if G.player.hourglass_active:
		return $CollisionShape2D.shape.collide(
			$CollisionShape2D.global_transform,
			G.player.get_node("HourglassEffect/Collision").shape,
			G.player.get_node("HourglassEffect/Collision").global_transform
		)
	else:
		return false

func _on_body_entered(body: Node2D) -> void:
	if body == G.player:
		player_in_fan = true
	if body is Centipede:
		body.in_fan = true

func _on_body_exited(body: Node2D) -> void:
	if body == G.player:
		player_in_fan = false
	if body is Centipede:
		body.in_fan = false
