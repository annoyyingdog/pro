extends RayCast3D

@export var steptarget: Node3D

func  physicsprocess(delta):
	var hitpoint = get_collision_point()
	if hitpoint:
		steptarget.global_position = hitpoint
