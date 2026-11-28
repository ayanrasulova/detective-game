class_name Item
extends Resource

var used_up : bool = false;
var new : bool = true;
@export_multiline var description : String = "This item is without a description.";
@export var texture : Texture2D = preload("res://sprites/ui/drawings/test1.png");
