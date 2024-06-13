extends Node3D

@onready var pause_menu = $CanvasLayer/Menu
@onready var light = $SubViewportContainer/SubViewport/player/Hand/SpotLight3D
var paused = Global.paused
func _ready():
	pause_menu.hide()
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()
	paused = Global.paused
func pauseMenu():
	if paused:
		pause_menu.hide()
		light.show()
		Engine.time_scale = 1
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Global.paused = false
		
	else:
		pause_menu.show()
		#light.hide()
		Engine.time_scale = 0
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		Global.paused = true



func _on_endgame_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://endgamescene.tscn")
