extends Button

var can_drop_data = true

signal answered(answer)

func can_drop_data(pos, data):    
    return can_drop_data
	
	
func drop_data(pos, data):
	emit_signal("answered", data.text)
	
func enable_drop():
	can_drop_data = true
	
func disable_drop():
	can_drop_data = false