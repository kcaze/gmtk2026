extends CanvasLayer

var dialogue_countdown = 0.0
var dialogue_idx = 0
var dialogue_countdown_max = 0.0
var dialogue = []
var should_roll_credits = false
var dialogue_running = false

func _ready():
	$DialogueBox.visible = false
	G.ui = self

func _process(delta):
	if not dialogue_running:
		return
	dialogue_countdown -= delta
	$DialogueBox/DialogueCountdown.text = str(ceil(dialogue_countdown))
	if dialogue_countdown <= 0:
		dialogue_idx += 1
		if dialogue_idx >= len(dialogue):
			end_dialogue()
		else:
			$DialogueBox/DialogueLabel.text = dialogue[dialogue_idx]
			dialogue_countdown = dialogue_countdown_max


func start_dialogue(d, countdown = 5, roll_credits=false):
	dialogue_running=true
	$DialogueBox.visible = true
	$DialogueBox/DialogueLabel.text = d[0]
	G.main.process_mode = ProcessMode.PROCESS_MODE_DISABLED
	dialogue_countdown = countdown
	dialogue_countdown_max = countdown
	dialogue = d
	dialogue_idx = 0
	should_roll_credits = roll_credits

func end_dialogue():
	dialogue_running = false
	if should_roll_credits:
		get_node("../Credits/AnimationPlayer").play("default")
	else:
		$DialogueBox.visible = false
		G.main.process_mode = ProcessMode.PROCESS_MODE_ALWAYS
