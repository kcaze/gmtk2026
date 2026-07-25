extends StaticBody2D

var active = false
var player_in_fan = false

func _physics_process(delta: float) -> void:
	if active and player_in_fan:
		G.player.in_fans[self] = true
	else:
		if self in G.player.in_fans:
			G.player.in_fans.erase(self)

func _process(delta: float) -> void:
	if not active and is_activated():
		activate()
	if active and not is_activated():
		deactivate()

func activate():
	active = true
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

func _on_body_exited(body: Node2D) -> void:
	if body == G.player:
		player_in_fan = false
