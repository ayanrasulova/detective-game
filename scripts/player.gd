extends CharacterBody2D

@export_range(0.0, 1000) var move_speed : float = 500;
@export_range(100.0, 1000.0) var gravity : float = 800;

func _physics_process(delta: float) -> void:
	#falling
	if not is_on_floor(): 
		velocity.y += gravity * delta;
	else: velocity.y = 0;
	
	#grounded movement
	var move_direction = Input.get_axis("move_left", "move_right");
	velocity.x = move_speed * move_direction;
	
	move_and_slide();
	pass;
