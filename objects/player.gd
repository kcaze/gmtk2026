extends CharacterBody2D

var jump_sustain = 0.0
var can_jump = 0.0
var jump_buffer = 0.0
var current_global_position = global_position
var apply_friction = true

const GRAVITY = 400.0
const FAN_STRENGTH = 600.0
const MAX_LIFT_SPEED = -300.0
const MAX_FALL_SPEED = 300.0
const FRICTION = 0.5
const MOVE_SPEED = 65.0
const JUMP_SQUASH = Vector2(0.85, 1.1)
const LAND_SQUASH = Vector2(1.3, 0.7)

var in_fans = {}

# Hourglass logic
var num_flips = 0
const HOURGLASS_RADIUS = 16
const MAX_HOURGLASS_DIST = 32
var hourglass_active = false

const TEX_HOURGLASS_INDICATOR_ON = preload("res://assets/sprites/hourglass-indicator-on.png")
const TEX_HOURGLASS_INDICATOR_OFF = preload("res://assets/sprites/hourglass-indicator-off.png")

var _velocity = Vector2(0,0)

func _ready():
	G.player = self

func _input(event):
	if event.is_action_pressed("right"):
		_velocity.x = MOVE_SPEED
		apply_friction = false
	if event.is_action_pressed("left"):
		_velocity.x = -MOVE_SPEED
		apply_friction = false
	if event.is_action_released("right"):
		if Input.is_action_pressed("left"):
			_velocity.x = -MOVE_SPEED
			apply_friction = false
	if event.is_action_released("left"):
		if Input.is_action_pressed("right"):
			_velocity.x = MOVE_SPEED
			apply_friction = false
	if event.is_action_pressed("flip") and num_flips > 0:
		flip_hourglass()
	

func _process(delta):
	if _velocity.x < 0:
		$PlayerSprite.flip_h = true
	if _velocity.x > 0:
		$PlayerSprite.flip_h = false
	$HourglassIndicator.visible = num_flips > 0
	var effect_pos = get_global_mouse_position() - global_position
	effect_pos = effect_pos.normalized() * min(effect_pos.length(), MAX_HOURGLASS_DIST)
	$HourglassEffect.global_position = global_position + effect_pos
	$HourglassEffect.visible = hourglass_active

func _physics_process(delta):
	# Physics
	apply_friction = not Input.is_action_pressed("right") and not Input.is_action_pressed("left")

	if in_fans.size() > 0:
		_velocity -= delta * Vector2(0, FAN_STRENGTH)
	else:
		_velocity += delta*Vector2(0, GRAVITY)
	_velocity.y = min(_velocity.y, MAX_FALL_SPEED)
	_velocity.y = max(_velocity.y, MAX_LIFT_SPEED)
	if apply_friction:
		_velocity.x *= FRICTION
	
	velocity = _velocity
	move_and_slide()
	
	if is_on_floor():
		_velocity.y = min(_velocity.y, 0)
	if is_on_ceiling():
		_velocity.y = max(_velocity.y, 0)
	
	current_global_position = global_position


func _on_hourglass_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flip":
		$Camera2D/Hourglass.rotation_degrees = 0
		if hourglass_active:
			$Camera2D/HourglassBackground.play()
	

func flip_hourglass():
	num_flips -= 1
	hourglass_active = not hourglass_active
	$Camera2D/Hourglass/AnimationPlayer.play("flip")
	$Camera2D/HourglassBackground.frame = 0
	$Camera2D/HourglassBackground.pause()

func _on_hourglass_background_animation_finished() -> void:
	hourglass_active = false
