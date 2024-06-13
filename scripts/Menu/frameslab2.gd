extends Label

@onready var menu = $"../../../../../../.."
func _ready():
	menu.framesChanged.connect(update)
	update()
	text = str(Global.frame_cap)

func update():
	pass
func _process(delta):
	text = str(Engine.max_fps)

