class_name RoomPoint
extends Node2D

#enum for places player can go to (avoid nullptr)
enum RoomPoints {
	OutsideSpawn,
	OutsideDoor,
	FirstFloorCenter,
	FirstFloorLeft,
	FirstFloorRight,
	Room10,
	Room11,
	SecondFloorCenter,
	SecondFloorRight,
	SecondFloorLeft,
	Room20,
	Room21,
	ThirdFloorCenter,
	ThirdFloorLeft,
	ThirdFloorRight,
	Room30,
	Room31
}

#const for the names of rooms that each point resides in
#this is used when displaying a room's name when the player enters
const ROOM_NAMES_BY_POINT : Dictionary[RoomPoints, String] = {
	RoomPoints.OutsideSpawn: "Outside",
	RoomPoints.OutsideDoor: "Outside",
	RoomPoints.FirstFloorCenter: "First Floor",
	RoomPoints.FirstFloorLeft: "First Floor",
	RoomPoints.FirstFloorRight: "First Floor",
	RoomPoints.Room10: "Room 10",
	RoomPoints.Room11: "Room 11",
	RoomPoints.SecondFloorCenter: "Second Floor",
	RoomPoints.SecondFloorLeft: "Second Floor",
	RoomPoints.SecondFloorRight: "Second Floor",
	RoomPoints.Room20: "Room 20",
	RoomPoints.Room21: "Room 21",
	RoomPoints.ThirdFloorCenter: "Third Floor",
	RoomPoints.ThirdFloorLeft: "Third Floor",
	RoomPoints.ThirdFloorRight: "Third Floor",
	RoomPoints.Room30: "Room 30",
	RoomPoints.Room31: "Room 31"
}

@export var location_index : RoomPoints;
