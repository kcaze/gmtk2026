@tool

class_name Track
extends Path2D

@export var repeats = false

const TEX_REPEATER = preload("res://assets/sprites/track-repeater.png")
const TEX_NONREPEATER = preload("res://assets/sprites/track-nonrepeater.png")
const TEX_INTERMEDIATE = preload("res://assets/sprites/track-intermediate.png")

var progress = 0.0
var curve_length = 0.0

func _ready():
	if curve == null:
		curve = Curve2D.new()
	curve_length = curve.get_baked_length()
	# Generate track sprites
	if not Engine.is_editor_hint():
		var pt = curve.sample_baked(0, true)
		var spr = Sprite2D.new()
		spr.texture = TEX_REPEATER if repeats else TEX_NONREPEATER
		spr.position = pt
		add_child(spr)
		for i in range(4, curve.get_baked_length(), 4):
			pt = curve.sample_baked(i, true)
			spr = Sprite2D.new()
			spr.texture = TEX_INTERMEDIATE
			spr.position = pt
			add_child(spr)
		pt = curve.sample_baked(curve.get_baked_length(), true)
		spr = Sprite2D.new()
		spr.texture = TEX_REPEATER if repeats else TEX_NONREPEATER
		spr.position = pt
		add_child(spr)
		
		$DebugLine2D.visible = false

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if curve != null and $DebugLine2D != null:
			$DebugLine2D.points = curve.get_baked_points()

func update_progress(delta: float):
	progress += delta
	if repeats:
		progress = fmod(progress, 2*curve_length)
		$PathFollow2D.progress = progress if progress < curve_length else 2*curve_length - progress
	else:
		progress = min(progress, curve_length)
		$PathFollow2D.progress = progress

func get_progress_position():
	return $PathFollow2D.global_position
