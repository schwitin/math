extends HBoxContainer


const PATH_BUTTON_CONTAINER = "CenterContainer/Buttons"


func _ready():
	for c in get_node(PATH_BUTTON_CONTAINER).get_children():
		if c.get_class() == "TextureButton" : 
			c.add_to_group("allButtons")

func _on_ResetButton_pressed():
	reset()
	
func reset():
	get_tree().call_group("allButtons", "set_state_grey")	
	
func set_abaco_state(blue, red):
	var all_nodes = get_tree().get_nodes_in_group("allButtons")
	var i = 0
	while i < all_nodes.size():
		if(i < blue):
			all_nodes[i].set_state_blue()
		else : if (i < blue + red):
			all_nodes[i].set_state_red()
		else:
			all_nodes[i].set_state_grey()
		i+=1

func _on_bullet_state_changed(source, state):
	var left_bullet = null
	var right_bullet = null
	var all_nodes = get_tree().get_nodes_in_group("allButtons")
	var source_idx = all_nodes.find(source)
	
	match source_idx:
		0: 
			right_bullet = all_nodes[source_idx+1]
		19:
			left_bullet = all_nodes[source_idx-1]
		_:
			right_bullet = all_nodes[source_idx+1]
			left_bullet = all_nodes[source_idx-1]

	
	if(left_bullet && left_bullet.current_state == left_bullet.State.GREY):
		#print("left is grey")
		source.set_state_grey()
		return	
		
	if(right_bullet && right_bullet.current_state == right_bullet.State.BLUE):
		#print("rigt is blue")
		source.set_state_blue()
		return
	
	if(left_bullet 
			&& left_bullet.current_state == left_bullet.State.BLUE 
			&& right_bullet 
			&& right_bullet.current_state == right_bullet.State.BLUE):
		#print("nb is blue")
		source.set_state_blue()
		return
	
	if(left_bullet 
			&& left_bullet.current_state == left_bullet.State.RED 
			&& right_bullet 
			&& right_bullet.current_state == right_bullet.State.RED):
		#print("nb is red")
		source.set_state_red()
		return
		
	if(right_bullet && right_bullet.current_state == right_bullet.State.RED
			&& state == source.State.GREY):
		#print("right is red, wont grey")
		source.set_state_blue()
		return
	
	if(left_bullet 
			&& left_bullet.current_state == left_bullet.State.RED 
			&& state == source.State.BLUE):
		#print("left is red, wont blue")
		source.set_state_red()
		return
		
	
	
		
	
		
