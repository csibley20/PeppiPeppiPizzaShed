extends CharacterBody3D

var Pizza = preload("res://Player/Pizza/pizza.tscn")

var camera

var speed = 8
const JUMP_VELOCITY = 4
const MOUSE_SENSIBILITY = 1200
var mouse_relative_x = 0
var mouse_relative_y = 0

var max_health = 12
var current_health = 12
var i_frames = false

var can_fire = true
var oven_player 

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	$"CanvasLayer/Game Over".visible = false
	$CanvasLayer/Pause.hide()
	
	camera = $Camera3D
	oven_player = $Camera3D/Oven/AnimationPlayer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("move_jump") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if Input.is_action_just_pressed("ui_pause"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			$CanvasLayer/Pause.hide()
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
			$CanvasLayer/Pause.show()
	
	if Input.is_action_just_pressed("primary_action"):
		if can_fire:
			can_fire = false
#			oven_player.play("Door_FlyOpen")
			shoot()
#			await oven_player.animation_finished
#			oven_player.play_backwards("Door_FlyOpen")
#			await oven_player.animation_finished
			await get_tree().create_timer(1.0, false).timeout
			can_fire = true
	
	if Input.is_action_pressed("sprint") and $CanvasLayer/TextureProgressBar.value > 0:
		speed = 8
		$CanvasLayer/TextureProgressBar.value -= 1
	else:
		speed = 5
	
	check_damage()
	
	if current_health <= 0:
		$"CanvasLayer/Game Over".visible = true
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
	
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / MOUSE_SENSIBILITY
		camera.rotation.x -= event.relative.y / MOUSE_SENSIBILITY
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 50)

func check_damage():
	for index in range(get_slide_collision_count()):
		var source = get_slide_collision(index)
		if source and source.get_collider():
			if source.get_collider().is_in_group("Damage_Source"):
				if (not i_frames):
					current_health -= source.get_collider().damage
					i_frames = true
					await get_tree().create_timer(1.0, false).timeout
					i_frames = false

func shoot():
	var b = Pizza.instantiate()
	b.rotation = $Camera3D.global_rotation
	b.velocity = -b.transform.basis.z * b.fire_velocity
	$Camera3D/Marker3D.add_child(b)


func _on_button_pressed():
		$CanvasLayer/Pause.hide()
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
