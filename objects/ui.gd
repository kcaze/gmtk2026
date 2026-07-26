extends CanvasLayer

var dialogue_countdown = 0.0
var dialogue_idx = 0
var dialogue_countdown_max = 0.0
var dialogue = []

func _ready():
	$DialogueBox.visible = false
	G.ui = self

func _process(delta):
	dialogue_countdown -= delta
	$DialogueBox/DialogueCountdown.text = str(ceil(dialogue_countdown))
	if dialogue_countdown <= 0:
		dialogue_idx += 1
		if dialogue_idx >= len(dialogue):
			end_dialogue()
		else:
			$DialogueBox/DialogueLabel.text = dialogue[dialogue_idx]
			dialogue_countdown = dialogue_countdown_max


func start_dialogue(d, countdown = 5):
	$DialogueBox.visible = true
	$DialogueBox/DialogueLabel.text = d[0]
	G.main.process_mode = ProcessMode.PROCESS_MODE_DISABLED
	dialogue_countdown = countdown
	dialogue_countdown_max = countdown
	dialogue = d
	dialogue_idx = 0

func end_dialogue():
	$DialogueBox.visible = false
	G.main.process_mode = ProcessMode.PROCESS_MODE_ALWAYS
