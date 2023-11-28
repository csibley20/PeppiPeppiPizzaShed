extends CharacterBody3D

var speed = 5
var accel = 10
var space_state
var target
var nav

var aggro = false
var damage = 5

func _ready():
	space_state = get_world_3d().direct_space_state
	nav = $NavigationAgent3D

func _process(delta):
	if target:
		var parameters = PhysicsRayQueryParameters3D.create(global_transform.origin, target.global_transform.origin)
		var result = space_state.intersect_ray(parameters)
		if result.collider.is_in_group("Player"):
			aggro = true
		if aggro:
			look_at(target.global_transform.origin, Vector3.UP)
			set_color(1,0,0)
			move_to_target(delta)
		else:
			set_color(0,1,0)

func _on_area_3d_body_entered(body):
	if (body.is_in_group("Player")):
		target = body


func _on_area_3d_body_exited(body):
	if (body.is_in_group("Player")):
		target = null
		aggro = false
		set_color(0, 1, 0)

func move_to_target(delta):
	nav.target_position = target.global_position
	
	var direction = (nav.get_next_path_position() - global_position).normalized()
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	
#	var direction = (target.transform.origin - transform.origin).normalized()
#	velocity = direction * speed * delta
	
	move_and_slide()

func set_color(r, g, b):
	$MeshInstance3D.mesh.material.set_albedo(Color(r,g,b))
