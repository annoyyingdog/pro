extends Control
@onready var world = $"../.."
@onready var mens = $MarginContainer
@onready var sets = $Options
@onready var full = Global.is_full
signal sensChanged
signal framesChanged

func _ready():
	pass

func _on_start_pressed():
	hide()
	Global.paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _on_settings_pressed():
	show_and_hide(sets, mens)
	
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		if Global.paused:
			show_and_hide(mens, sets)
		else:
			pass
	
func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	pass # Replace with function body.


func _on_back_pressed():
	Global.paused = false
	show_and_hide(mens, sets)
	
	pass # Replace with function body.


func _on_windowed_toggled(toggled_on):
	if toggled_on == true:

		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	else:

		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	pass # Replace with function body.


func _on_fullscreen_toggled(toggled_on):

	if toggled_on == true:

		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

	else:

		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	pass # Replace with function body.


func _on_vsync_toggled(toggled_on):

	if toggled_on == true:

		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

	else:

		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	pass # Replace with function body.


func _on_sens_value_changed(value):
	Global.sens = value
	sensChanged.emit()
	pass # Replace with function body.
#func _process(delta):
	


func _on_frame_slider_value_changed(value):
	Engine.max_fps = value
	framesChanged.emit()
	pass # Replace with function body.
