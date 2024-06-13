extends Control
@onready var menu = $MarginContainer/MenuCont
@onready var settings = $"../Options/MarginContainer/Skibidi"
@onready var sets = $"../Options"
@onready var mens = $"."
@export var Mouse_Sensitivity = 0.55# Global.sens
@onready var thing = $"../../../AnimationPlayer"
signal sensChanged
signal framesChanged

func _ready():
	Global.paused = false
	thing.play("new_animation")
	sets.hide()
	Engine.max_fps = Global.frame_cap
	Global.full_sens = Mouse_Sensitivity
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	Global.paused = false

func _on_settings_pressed():
	show_and_hide(sets, mens)

	
func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_back_pressed():
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
		Global.is_full = true

	else:

		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Global.is_full = false

	pass # Replace with function body.


func _on_vsync_toggled(toggled_on):

	if toggled_on == true:

		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

	else:

		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	pass # Replace with function body.


func _on_sens_value_changed(value):
	Mouse_Sensitivity = value
	Global.sens = Mouse_Sensitivity
	sensChanged.emit()
	pass # Replace with function body.
#func _process(delta):
	


func _on_frame_slider_value_changed(value):
	Engine.max_fps = value
	framesChanged.emit()
	pass # Replace with function body.
