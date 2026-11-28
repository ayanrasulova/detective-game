extends Control

var show_notification : bool = false;

func _ready() -> void:
	hide();
	GameManager.evidence_collected.connect(func():
		show_notification = true;
		show());
	GameManager.new_evidence_viewed.connect(_check_for_notification_removal);
	GameManager.journal_opened.connect(func(): hide());
	GameManager.journal_closed.connect(func(): if show_notification: show());

func _check_for_notification_removal() -> void:
	var new_collected_items : Array[Item] = GameManager.get_collected_items().filter(func(i : Item): return i.new);
	var new_collected_evidence : Array[Evidence] = GameManager.get_collected_evidence().filter(func(e : Evidence): return e.new);
	if new_collected_evidence.is_empty() and new_collected_items.is_empty():
		show_notification = false;
	pass;
