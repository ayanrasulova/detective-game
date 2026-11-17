class_name InteractPrompt
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var label_offset : Vector2;

var target : Node2D = null;

var v : bool = false;

func set_target(t: Node2D) -> void:
	if(t != null and t != target): animation_player.play("reveal");
	target = t;
	v = t != null;
	

func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target) or UI.dialogue_balloon_visible:
		v = false;
	elif target != null and is_instance_valid(target):
		v = true;
		global_position = target.global_position + label_offset
	modulate.a = lerp(modulate.a, 1.0 if v else 0.0, delta * 10);
