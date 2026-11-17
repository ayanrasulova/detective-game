class_name RoomPoint
extends Node2D

#enum for places player can go to (avoid nullptr)
enum RoomPoints {
	OutsideSpawn,
	OutsideDoor,
	FirstFloorCenter
}

@export var location_index : RoomPoints;
