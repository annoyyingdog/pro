extends Marker3D

@export var steptarget: Node3D
@export var stepdistance: float = 3.0

@export var adjacenttarget: Node3D

var isstepping := false

func process(delta):
	if !isstepping && !adjacenttarget.isstepping && abs(global_position.distance_to(steptarget.global_position)) > stepdistance:
		step()

func step():
	var targetpos = steptarget.global_position
	var halfway = (global_position + steptarget.global_position) / 2
	isstepping = true
	
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", halfway + owner.basis.y, 0.1)
	t.tween_property(self, "global_position", targetpos, 0.1)
	t.tween_callback(func(): isstepping = false)
