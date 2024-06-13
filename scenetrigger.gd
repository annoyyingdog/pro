extends Node3D

@export var path = "res://"

func _ready():
	pass # Replace with function body.
	
func areabody(body):
	if body is Player && body.is_in_group("player"):
		SceneSwitcher.changeScene(path)


