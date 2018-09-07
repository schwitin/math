extends Sprite

var smile_sad
var smile_jolly

	

func set_sad():
	texture = smile_sad

func set_jolly():
	texture = smile_jolly



func _ready():
	smile_sad = load("res://Smile/smilie-sad.png")
	smile_jolly = load("res://Smile/smilie-jolly.png")
	texture = smile_jolly