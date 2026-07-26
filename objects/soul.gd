extends AnimatedSprite2D

var is_active = true
var player_colliding = false
const RESPAWN_TIME = 2.0

func _process(delta: float) -> void:
	if player_colliding and is_active:
		_add_flip()
	if not is_active and $RespawnTimer.is_stopped():
		$RespawnTimer.start(RESPAWN_TIME)


func _on_body_entered(body: Node2D) -> void:
	if body == G.player:
		player_colliding = true

func _on_body_exited(body: Node2D) -> void:
	if body == G.player:
		player_colliding = false

func _add_flip():
	G.player.flip_hourglass()
	is_active = false
	animation = "inactive"
	$CPUParticles2D.restart()
	$CPUParticles2D.emitting = true

func _on_respawn_timer_timeout() -> void:
	is_active = true
	animation = "active"
	$AnimationPlayer.play("fade_in")
	$RespawnTimer.stop()
