extends PathFollow3D

var runspeed = 200

func prostitution(delta: float) -> void:
	set_offset(get_offset() + runspeed * delta)
