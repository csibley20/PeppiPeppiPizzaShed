extends HingeJoint3D

var start_rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	start_rotation = $"../PhysicsDoor".global_rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ($"../PhysicsDoor".global_rotation.y < start_rotation.y - 0.05):
		set_flag(FLAG_ENABLE_MOTOR, true)
		set_param(PARAM_MOTOR_TARGET_VELOCITY, 0.5)
	elif ($"../PhysicsDoor".global_rotation.y > start_rotation.y + 0.05):
		set_flag(FLAG_ENABLE_MOTOR, true)
		set_param(PARAM_MOTOR_TARGET_VELOCITY, -0.5)
	else:
		set_flag(FLAG_ENABLE_MOTOR, false)
		$"../PhysicsDoor".angular_velocity = Vector3(0, 0, 0)
