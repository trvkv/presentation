@tool
extends Node

enum TerrainTypes {DIRT, ICE}

var TerrainSettings := {
	TerrainTypes.DIRT: {
		'modulate': Color('#7a5000'),
		'physics_material_override': preload("res://Resources/Physics/dirt.tres")
	},
	TerrainTypes.ICE: {
		'modulate': Color('#0000ff'),
		'physics_material_override': preload("res://Resources/Physics/ice.tres")
	}
}
