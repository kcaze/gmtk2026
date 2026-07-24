extends AnimatedSprite2D

var is_active = true
const RESPAWN_TIME = 2

func _on_body_entered(body: Node2D) -> void:
	if body == G.player and is_active:
		flip()

func flip():
	G.player.flip_hourglass()
	is_active = false
	animation = "inactive"
	$RespawnTimer.start(RESPAWN_TIME)


func _on_respawn_timer_timeout() -> void:
	is_active = true
	animation = "active"
