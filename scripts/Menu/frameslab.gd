extends Label

@onready var menu = $"../../../../../../../Menu"
func _ready():
	menu.framesChanged.connect(update)
	update()
	text = str(Global.frame_cap)


func update():
	text = str(Engine.max_fps)

