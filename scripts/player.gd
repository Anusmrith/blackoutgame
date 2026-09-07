extends CharacterBody2D

const SPEED = 350.0
const JUMP_VELOCITY = -350.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var run_sound: AudioStreamPlayer2D = $RunSound
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var heartbeat: AudioStreamPlayer2D = $Heartbeat



@onready var progress_bar: ProgressBar = $"../CanvasLayer2/ProgressBar"
@onready var darkness_overlay: ColorRect = $"../CanvasLayer/DarknessOverlay"

var in_light = false

var darkness = 0
const MAX_DARKNESS = 100.0
const DARKNESS_SPEED = 20.0
const RECOVER_SPEED = 35.0

func _physics_process(delta):

	# Gravity
	if !is_on_floor():
		velocity += get_gravity() * delta

		if run_sound.playing:
			run_sound.stop()

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

		if run_sound.playing:
			run_sound.stop()

	# Movement
	var direction = Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * SPEED

		if is_on_floor():
			if !run_sound.playing:
				run_sound.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

		if run_sound.playing:
			run_sound.stop()

	# Flip sprite
	if direction != 0:
		sprite.flip_h = direction < 0

	# Animations
	if !is_on_floor():
		if velocity.y < 0:
			sprite.play("jump")
		else:
			sprite.play("fall")
	else:
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("run")

	# Darkness System
	if in_light:
		darkness -= RECOVER_SPEED * delta
	else:
		darkness += DARKNESS_SPEED * delta

	darkness = clamp(darkness, 0.0, MAX_DARKNESS)

	# Update UI
	progress_bar.value = darkness

	# Screen Darkness
	darkness_overlay.color.a = darkness / MAX_DARKNESS

	# Heartbeat
	if darkness >= 70:
		if !heartbeat.playing:
			heartbeat.play()

		# Faster heartbeat as darkness increases
		heartbeat.pitch_scale = lerp(1.0, 1.8, darkness / 100.0)
	else:
		if heartbeat.playing:
			heartbeat.stop()

	# Death
	if darkness >= MAX_DARKNESS:
		get_node("../CanvasLayer4/DeathMenu").show_menu()
		
		

	move_and_slide()

func _restart_level():
	get_tree().reload_current_scene()
