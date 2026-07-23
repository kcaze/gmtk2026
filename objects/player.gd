extends CharacterBody2D

var jump_sustain = 0.0
var can_jump = 0.0
var jump_buffer = 0.0
var current_global_position = global_position
var apply_friction = true

const GRAVITY = 300.0
const MAX_FALL_SPEED = 300.0
const FRICTION = 0.5
const JUMP_SPEED = -160.0
const JUMP_SUSTAIN = 0.12
const JUMP_SUSTAIN_DECAY_HELD = 0.35
const JUMP_BUFFER = 0.1
const MOVE_SPEED = 80.0
const JUMP_SQUASH = Vector2(0.85, 1.1)
const LAND_SQUASH = Vector2(1.3, 0.7)
const COYOTE_TIME = 0.1
const COYOTE_TIME_SPECIAL_DECAY = 0.125

# Hourglass logic
var sands_time = 0.0
var resetting_hourglass = false
const HOURGLASS_RADIUS = 32
const SANDS_DECREASE_RATE = 0.3

func _ready():
	G.player = self

func _input(event):
	if event.is_action_pressed("jump"):
		jump_buffer = JUMP_BUFFER
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

func _physics_process(delta):
	# sands_time
	sands_time = max(sands_time-delta*SANDS_DECREASE_RATE, 0)
	($HourglassEffectCollision.shape as CircleShape2D).radius = sands_time * HOURGLASS_RADIUS
	($HourglassEffect.material as ShaderMaterial).set_shader_parameter("percent", sands_time)
	
	if resetting_hourglass:
		sands_time = lerpf(sands_time, 1.0, 0.5)
		if sands_time >= 0.99:
			sands_time = 1.0
			resetting_hourglass = false
	
	# Physics
	apply_friction = not Input.is_action_pressed("right") and not Input.is_action_pressed("left")
	
	if is_on_floor():
		can_jump = max(can_jump, COYOTE_TIME)
	else:
		can_jump = max(can_jump-(1 if velocity.y > 0 else COYOTE_TIME_SPECIAL_DECAY)*delta, 0.0)
	
	jump_buffer = max(0, jump_buffer - delta)
	if jump_buffer > 0 and can_jump:
		jump_sustain = JUMP_SUSTAIN
		jump_buffer = 0
		can_jump = 0
	if jump_sustain > 0:
		velocity.y = JUMP_SPEED*pow(jump_sustain/JUMP_SUSTAIN, 0.5)
		jump_sustain -= (1 if not Input.is_action_pressed("jump") else JUMP_SUSTAIN_DECAY_HELD)*delta
		
		# Hit apex of jump, so reset hourglass
		if jump_sustain <= 0:
			resetting_hourglass = true
		
		jump_sustain = max(0, jump_sustain)

	velocity += delta*Vector2(0, GRAVITY)
	velocity.y = min(velocity.y, MAX_FALL_SPEED)
	if apply_friction:
		velocity.x *= FRICTION
		
	# Push up or down 1 pixel to avoid getting stuck on ledges
	if abs(velocity.x) > 1 and test_move(transform, Vector2(sign(velocity.x), 0)):
		for dy in [-2,-1,1,2]:
			if not test_move(transform.translated(Vector2(0,dy)), Vector2(sign(velocity.x), 0)):
				global_position.y += dy
				break
	
	move_and_slide()
	
	if is_on_floor():
		velocity.y = min(velocity.y, 0)
	if is_on_ceiling():
		velocity.y = max(velocity.y, 0)
	
	current_global_position = global_position
