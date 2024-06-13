extends Label
@onready var menu = $"."
func _ready():
	text = str(Global.sens * 100)
func _process(delta):
	update()


func update():
	text = str(Global.sens * 100)

