extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameManager.evidence_collected.connect(func(): animation_player.play("reveal"));
