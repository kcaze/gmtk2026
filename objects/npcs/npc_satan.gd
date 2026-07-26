extends Node2D

var DIALOGUE = [
	"SATAN:[color=#939090] Oh, it strikes, it strikes![/color]",
	"[color=#939090]The hour of midnight is near![/color]",
	"[color=#939090]Hurry, hurry, to the nightmare...[/color]",
	"[color=#996262]*The hourglass is enhanced*[/color]"
]
var player_entered = false
var active = false
var dialogue_can_play = true

func _ready():
	$InteractableArea.body_entered.connect(_on_body_entered)
	$InteractableArea.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body == G.player:
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
		G.player.upgrades += 1
		G.ui.start_dialogue(DIALOGUE, 3)

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
