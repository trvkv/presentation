extends Node

class_name Util

static func crash_if_false(condition: bool, message: String = "") -> void:
	assert(condition, message)
	# TODO: handle here for non-debug builds
