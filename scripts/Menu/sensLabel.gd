extends Label

@onready var menu = $"../../../../../../../Menu"
func _ready():
	menu.sensChanged.connect(update)
	update()


func update():
	text = str(Global.sens * 100)


