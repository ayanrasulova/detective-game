class_name JournalItem
extends TextureRect

@export var SELECTED_PANEL_COLOR : Color;
@export var UNSELECTED_PANEL_COLOR : Color;

var associated_item : Item;

@onready var panel: Panel = $Panel
@onready var button_prompt: TextureRect = $ButtonPrompt
@onready var exclamation: RichTextLabel = $Exclamation


func _ready() -> void:
	button_prompt.hide();
	panel.modulate = UNSELECTED_PANEL_COLOR;
	focus_entered.connect(_on_focus_entered);
	focus_exited.connect(_on_focus_exited);

func _on_focus_entered() -> void:
	panel.modulate = SELECTED_PANEL_COLOR
	if GameManager.selecting_evidence: button_prompt.show();
	associated_item.new = false;
	var tween = create_tween();
	tween.tween_property(exclamation, "modulate:a", 0, 0.2);
	tween.play();
	pass;

func _on_focus_exited() -> void:
	panel.modulate = UNSELECTED_PANEL_COLOR;
	button_prompt.hide();
	pass;
