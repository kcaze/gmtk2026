@tool

class_name Track
extends Path2D

@export var repeats = false

const TEX_REPEATER = preload("res://assets/sprites/track-repeater.png")
const TEX_NONREPEATER = preload("res://assets/sprites/track-nonrepeater.png")
const TEX_INTERMEDIATE = preload("res://assets/sprites/track-intermediate.png")

func _ready():
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
		spr.texture = TEX_REPEATER if repeats else TEX_NONREPEATER
		spr.position = pt
		add_child(spr)
		
		$DebugLine2D.visible = false

func _process(delta: float) -> void:
	if curve != null and $DebugLine2D != null:
		$DebugLine2D.points = curve.get_baked_points()
