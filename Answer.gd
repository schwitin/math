extends Button

func get_drag_data(pos):
	var clone = self.duplicate()
	
	clone.rect_pivot_offset = Vector2(300,300)
	clone.rect_scale = Vector2(1.1,1.1)
	
	set_drag_preview(clone)
	return self
	
func can_drop_data(pos, data):
	return false
	
