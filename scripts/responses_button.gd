extends Button


func _process(delta: float) -> void:
	custom_minimum_size.x = lerpf(custom_minimum_size.x, 615 if has_focus() else 600, 20 * delta);
