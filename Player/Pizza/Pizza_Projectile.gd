extends Area3D

signal pizza_impact

@export var fire_velocity = 40
var g = ProjectSettings.get_setting("physics/3d/default_gravity")
var damage = 16

var velocity = Vector3.ZERO

func _ready():
	set_as_top_level(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y -= g * delta
	transform.origin += velocity * delta

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(damage)
		queue_free()
	if body.is_in_group("Freezer"):
		body.get_parent().trigger()
		queue_free()

func _on_timer_timeout():
	queue_free()


func _on_area_3d_body_entered(body):
	if !body.is_in_group("Player"):
		queue_free()
