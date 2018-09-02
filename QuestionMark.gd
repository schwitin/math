extends Button

signal answered(answer)

func can_drop_data(pos, data):    
    return true
	
func drop_data(pos, data):
	#self.text = data.text
	emit_signal("answered", data.text)