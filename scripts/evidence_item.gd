class_name JournalEvidenceItem
extends RichTextLabel


@onready var backing_panel: Panel = $Panel
@export var selected_color : Color;
@export var unselected_color : Color;

@onready var exclamation : RichTextLabel = $Notification
@onready var select_prompt: TextureRect = $SelectPrompt

var associated_evidence : Evidence;

func _ready() -> void:
	exclamation.show();
	focus_neighbor_left = self.get_path();
	focus_neighbor_right = self.get_path();
	backing_panel.modulate = unselected_color;
	select_prompt.hide();
	focus_entered.connect(_on_focus_changed);
	focus_exited.connect(_on_focus_changed)

func _on_focus_changed() -> void:
	if has_focus():
		if associated_evidence.new:
			associated_evidence.new = false;
			GameManager.viewed_new_evidence();
		backing_panel.modulate = selected_color;
		var tween = create_tween(); #hide the exclamation point when the user hovers over the evidence
		tween.tween_interval(0.2);
		tween.tween_property(exclamation, "modulate:a", 0, 0.5);
		tween.play();
		if GameManager.selecting_evidence:
			select_prompt.show();
	else:
		backing_panel.modulate = unselected_color;
		select_prompt.hide();
		
