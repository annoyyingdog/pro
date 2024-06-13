
extends RayCast3D

@export var step_target: Node3D 

func _physics_process(_delta):
	var hit_point = get_collision_point()
	if step_target != null:
		if hit_point != null:
			step_target.global_position = hit_point
