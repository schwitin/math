extends TextureButton

enum State {
	BLUE,
	RED,
	GREY
}

var current_state

var _texture_red = null
var _texture_blue = null
var _texture_grey = null

signal state_changed(source, state)

func _ready():
	_texture_red = preload("res://Abaco/sphere_red.png")
	_texture_blue = preload("res://Abaco/sphere.png")
	_texture_grey = preload("res://Abaco/sphere_grey.png")
	
	texture_normal = _texture_grey
	current_state = State.GREY
	
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _pressed():
	match current_state:
		State.GREY:
			_set_state(State.BLUE)
		State.BLUE:
			_set_state(State.RED)
		State.RED:
			_set_state(State.GREY)
	
func _set_state(state):
	current_state = state
	match current_state:
		State.GREY:			
			texture_normal = _texture_grey
		State.BLUE:
			texture_normal = _texture_blue
		State.RED:
			texture_normal = _texture_red
			
	emit_signal("state_changed", self, current_state)

func set_state_grey():
	current_state = State.GREY
	texture_normal = _texture_grey

func set_state_red():
	current_state = State.RED
	texture_normal = _texture_red
	
func set_state_blue():
	current_state = State.BLUE
	texture_normal = _texture_blue
	
	
	
