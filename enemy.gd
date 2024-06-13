extends Node3D


@onready var path_follow: PathFollow3D = $Path2D/PathFollow2D
@export var speed = 100

func probatio(delta: float) -> void:
	path_follow.progress += speed * delta
