extends CharacterBody2D

var jump_sustain = 0.0
var can_jump = 0.0
var jump_buffer = 0.0
var current_global_position = global_position
var apply_friction = true
var upgrades = 0

const GRAVITY = 400.0
const FAN_STRENGTH = 420.0
const MAX_LIFT_SPEED = -300.0
const MAX_FALL_SPEED = 300.0
const FRICTION = 0.5
const MOVE_SPEED = 65.0
const JUMP_SQUASH = Vector2(0.85, 1.1)
const LAND_SQUASH = Vector2(1.3, 0.7)

var in_fans = {}

# Hourglass logic
const HOURGLASS_RADIUS = 16
const MAX_HOURGLASS_DIST = 512
var hourglass_active = false
var hourglass_aura_time = 0.0

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

func _process(delta):
	if _velocity.x < 0:
		$PlayerSprite.flip_h = true
	if _velocity.x > 0:
		$PlayerSprite.flip_h = false
	var effect_pos = get_global_mouse_position()
	
	# Clamp to visible screen rect
	var viewport = get_viewport()
	var rect = viewport.canvas_transform.affine_inverse() * viewport.get_visible_rect()
	effect_pos.x = clampf(effect_pos.x, rect.position.x, rect.end.x)
	effect_pos.y = clampf(effect_pos.y, rect.position.y, rect.end.y)
	
	$HourglassEffect.global_position = effect_pos
	$HourglassEffect.animation = "on" if hourglass_active else "off"
	$HourglassEffect.modulate.a = 0.8 if hourglass_active else 0.25
	$HourglassEffect/HourglassBackground.visible = hourglass_active
	hourglass_aura_time += delta
	$HourglassEffect/Aura.visible = hourglass_active
	($HourglassEffect/Aura.material as ShaderMaterial).set_shader_parameter("t", hourglass_aura_time)

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
			$HourglassEffect/HourglassBackground.play(str(upgrades))
	

func flip_hourglass():
	hourglass_active = true
	$Camera2D/Hourglass/AnimationPlayer.play("flip")
	$HourglassEffect/HourglassBackground.frame = 0
	$HourglassEffect/HourglassBackground.pause()

func _on_hourglass_background_animation_finished() -> void:
	hourglass_active = false
