extends Node

var sens = 0.55
var frame_cap = 60
var is_full = false
var is_borderless = false
var is_vsync = false
var paused = false
var full_sens = null

func _process(_delta):
	if paused:
		Engine.time_scale = 0
	else:
		Engine.time_scale = 1

