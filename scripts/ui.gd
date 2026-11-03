extends CanvasLayer


var dialogue_balloon_visible : bool = false;

func start_dialogue(dialogue_filename : String) -> void:
	if dialogue_balloon_visible:
		push_warning("trying to start dialogue " + dialogue_filename + " while dialogue box is already up.");
		return;
	DialogueManager.show_dialogue_balloon_scene("res://scenes/dialogue_balloon/balloon.tscn", load("res://dialogue/" + dialogue_filename + ".dialogue"));
	dialogue_balloon_visible = true;
	pass;

func start_dialogue_at_label(dialogue_filename : String, label : String) -> void:
	if dialogue_balloon_visible:
		push_warning("trying to start dialogue " + dialogue_filename + " at label " + label + " while dialogue box is already up.");
		return;
	DialogueManager.show_dialogue_balloon_scene("res://scenes/dialogue_balloon/balloon.tscn", load("res://dialogue/" + dialogue_filename + ".dialogue"), label);
	dialogue_balloon_visible = true;

func start_dialogue_resource_at_label(resource : DialogueResource, label : String) -> void:
	DialogueManager.show_dialogue_balloon_scene("res://scenes/dialogue_balloon/balloon.tscn", resource, label);
	dialogue_balloon_visible = true;
