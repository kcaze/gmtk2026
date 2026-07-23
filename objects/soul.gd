extends AnimatedSprite2D

var is_active = true


func _on_body_entered(body: Node2D) -> void:
	if body == G.player and is_active:
		G.player.flip_hourglass()
		is_active = false
		animation = "inactive"
