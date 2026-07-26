extends Node2D

var DIALOGUE = [
	"NIGHT MARE:[color=#ea323c] O lente, lente, currite noctis equi.[/color]",
	"[color=#ea323c]O run slowly, slowly, horses of the night.[/color]",
	"[color=#ea323c]Midnight strikes, the hour of reckoning![/color]",
	"[color=#ea323c]Things fall apart. The centre cannot hold.[/color]",
	"[color=#ea323c]Mere anarchy is loosed upon the world![/color]",
]
var player_entered = false
var active = false
var dialogue_can_play = true
var appeared = false

func _ready():
	$InteractableArea.body_entered.connect(_on_body_entered)
	$InteractableArea.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body == G.player:
		#if not appeared and not $AnimationPlayer.is_playing():
			#$AnimationPlayer.play("appear")
			#appeared = true
		player_entered = true

func _on_body_exited(body: Node2D):
	if body == G.player:
		player_entered = false

func _process(delta: float) -> void:
	if not active and is_activated():
		activate()
	if active and not is_activated():
		deactivate()
	
	if active and player_entered and dialogue_can_play:
		print("hi")
		dialogue_can_play = false
		G.ui.start_dialogue(DIALOGUE, 1, true)

func activate():
	active = true
	$AnimatedSprite2D.play("active")


func deactivate():
	active = false
	$AnimatedSprite2D.play("idle")

func is_activated():
	if G.player.hourglass_active:
		return $CollisionShape2D.shape.collide(
			$CollisionShape2D.global_transform,
			G.player.get_node("HourglassEffect/Collision").shape,
			G.player.get_node("HourglassEffect/Collision").global_transform
		)
	else:
		return false
