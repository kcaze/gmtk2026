extends CharacterBody2D

var jump_sustain = 0.0
var can_jump = 0.0
var jump_buffer = 0.0
var current_global_position = global_position
var apply_friction = true

const GRAVITY = 400.0
const MAX_FALL_SPEED = 300.0
const FRICTION = 0.5
const MOVE_SPEED = 65.0
const JUMP_SQUASH = Vector2(0.85, 1.1)
const LAND_SQUASH = Vector2(1.3, 0.7)

# Hourglass logic
var sands_idx = 0
const HOURGLASS_RADIUS = 32
const NUM_SANDS_TICK = 2.0

func _ready():
	G.player = self

func _input(event):
	if event.is_action_pressed("right"):
		velocity.x = MOVE_SPEED
		apply_friction = false
	if event.is_action_pressed("left"):
		velocity.x = -MOVE_SPEED
		apply_friction = false
	if event.is_action_released("right"):
		if Input.is_action_pressed("left"):
			velocity.x = -MOVE_SPEED
			apply_friction = false
	if event.is_action_released("left"):
		if Input.is_action_pressed("right"):
			velocity.x = MOVE_SPEED
			apply_friction = false

func _process(delta):
	if velocity.x < 0:
		$PlayerSprite.flip_h = true
	if velocity.x > 0:
		$PlayerSprite.flip_h = false
	$Camera2D/Hourglass.frame = sands_idx

func _physics_process(delta):
	# sands_time
	($HourglassEffectCollision.shape as CircleShape2D).radius = sands_idx * HOURGLASS_RADIUS
	($HourglassEffect.material as ShaderMaterial).set_shader_parameter("percent", 1.0 - sands_idx / NUM_SANDS_TICK)
	
	# Physics
	apply_friction = not Input.is_action_pressed("right") and not Input.is_action_pressed("left")

	velocity += delta*Vector2(0, GRAVITY)
	velocity.y = min(velocity.y, MAX_FALL_SPEED)
	if apply_friction:
		velocity.x *= FRICTION
	
	move_and_slide()
	
	if is_on_floor():
		velocity.y = min(velocity.y, 0)
	if is_on_ceiling():
		velocity.y = max(velocity.y, 0)
	
	current_global_position = global_position


func _on_hourglass_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flip":
		$Camera2D/Hourglass.rotation_degrees = 0
		$Camera2D/HourglassBackground.frame = 0
		if sands_idx < NUM_SANDS_TICK:
			$Camera2D/HourglassBackground.play()
	

func flip_hourglass():
	sands_idx = NUM_SANDS_TICK - sands_idx
	$Camera2D/Hourglass/AnimationPlayer.play("flip")
	$Camera2D/HourglassBackground.frame = 0
	$Camera2D/HourglassBackground.pause()


func _on_hourglass_background_animation_finished() -> void:
	sands_idx += 1
	if sands_idx < NUM_SANDS_TICK:
		$Camera2D/HourglassBackground.play()
