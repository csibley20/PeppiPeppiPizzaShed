extends CharacterBody3D

var speed = 7
var accel = 10
var space_state
var target
var nav

const TOLERANCE = 4.0

var aggro = false
var damage = 5
var health = 25

enum {
	IDLE,
	WANDER
}
var state = IDLE

var start_position
var target_position
var target_rotation

var idle_timer_on = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	space_state = get_world_3d().direct_space_state
	nav = $NavigationAgent3D
	start_position = global_position
	target_position = global_position
	target_rotation = global_rotation_degrees

func _process(delta):
	if health <= 0:
		get_node("/root").get_child(0).on_enemy_killed()
		queue_free()
	if target:
		var parameters = PhysicsRayQueryParameters3D.create(global_transform.origin, target.global_transform.origin)
		var result = space_state.intersect_ray(parameters)
		if result.collider.is_in_group("Player"):
			aggro = true
		if aggro:
			look_at(target.global_transform.origin, Vector3.UP)
			set_color("res://Enemies/Basic/red.tres")
			move_to_target(delta)
		else:
			set_color("res://Enemies/Basic/green.tres")

	if not aggro:
		velocity.y -= gravity * delta
		
		match state:
			IDLE:
				if not idle_timer_on:
					state = WANDER
					
					var target_vector = Vector3(randf_range(-5, 5), 0, randf_range(-5, 5))
					target_position = start_position + target_vector
					var new_rotation = Vector3(0, randf_range(-90, 90), 0)
					target_rotation = rotation_degrees + new_rotation
					
			WANDER:
				var direction = (target_position - global_position).normalized()
				var acceleration_vector = direction * speed
				velocity = acceleration_vector
				
				rotation_degrees += Vector3(0, 2, 0)
				
				if (target_position - global_position).length() < TOLERANCE or rotation == target_rotation:
					state = IDLE
					idle_timer_on = true
					$Timer.start(2.0)
				
		move_and_slide()
			
		

func _on_area_3d_body_entered(body):
	if (body.is_in_group("Player")):
		target = body


func _on_area_3d_body_exited(body):
	if (body.is_in_group("Player")):
		target = null
		aggro = false
		set_color("res://Enemies/Basic/green.tres")

func move_to_target(delta):
	nav.target_position = target.global_position

	var direction = (nav.get_next_path_position() - global_position).normalized()
	var new_velocity = velocity.lerp(direction * speed, accel * delta)
	nav.set_velocity(new_velocity)

func set_color(color):
	$MeshInstance3D.mesh.material = load(color)

func take_damage(amount):
	health -= amount

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()


func _on_timer_timeout():
	idle_timer_on = false
