extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var score=0

func set_score(_score):
	if(_score > 10):
		_score = 10
	
	if(_score < -10):
		_score=-10
	
	score = _score * -1
	update()



func _ready():
	set_score(10)

func _draw():
	var pos = Vector2(60,60)
	draw_circle(pos, 60.0, Color('#ffff00') )
	draw_circle(Vector2(30,30), 10.0, Color('#000000') )	
	draw_circle(Vector2(90,30), 10.0, Color('#000000') )
	draw_line( Vector2 (60,50), Vector2(60,70), Color('#000000'), 10.0)

	draw_line( Vector2 (40,90), Vector2(80,90), Color('#000000'), 10.0)
	
	draw_line( Vector2 (30,90+score), Vector2(40,90), Color('#000000'), 10.0)
	draw_line( Vector2 (90,90+score), Vector2(80,90), Color('#000000'), 10.0)
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
