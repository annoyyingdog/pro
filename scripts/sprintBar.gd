extends TextureProgressBar

@export var player: Player

func _ready():
	player.staminaChanged.connect(update)
	update()


func update():
	value = player.stamina * 200 / player.MAX_STAMINA
	#print(value)
	
	if player.sprinting:
		self.show()  # Show the stamina bar
	elif player.stamina == 200:
		self.hide()  # Hide the stamina bar
