extends Node

class_name StateMachine

#
# inner State class
#

class State:

	var state_name: String:
		get = get_name, set = set_name

	func _init(name: String) -> void:
		set_name(name)

	func set_name(state: String) -> void:
		state_name = state

	func get_name() -> String:
		return state_name

	func enter() -> void:
		pass

	func exit() -> void:
		pass

	func tick(_delta) -> void:
		pass

	func physics_tick(_delta) -> void:
		pass

	func input() -> void:
		pass

	func get_transition() -> String:
		return String()

	func is_valid() -> bool:
		return !state_name.is_empty()

#
# end of State class
#

var states: Array[State] = []:
	set(incoming_states):
		states = incoming_states
		for incoming_state in states:
			var array_size = states.filter(
				func(saved_state):
					return saved_state.state_name == incoming_state.state_name
			).size()
			Util.crash_if_false(
				array_size <= 1,
				"Duplicated states in the incoming states found"
			)

var active_state: State = null

func _init(default_state: State = null) -> void:
	active_state = default_state

func _ready():
	if active_state == null:
		return
	active_state.enter()

func _process(delta):
	if active_state == null:
		return

	var transition_state: String = active_state.get_transition()
	if ! transition_state.is_empty():
		var found_state: State = get_state_by_name(transition_state)
		if found_state.is_valid():
			active_state.exit()
			active_state = found_state
			active_state.enter()

	active_state.tick(delta)

func _physics_process(delta):
	if active_state == null:
		return

	active_state.tick(delta)

func add_state(state: State) -> void:
	# sanitize the added state
	Util.crash_if_false(
		state not in states,
		"Duplicated states in the state machine found"
	)
	states.append(state)

func get_state_by_name(state_name: String) -> State:
	return states.filter(
		func(state): return state_name == state.state_name
	)[0]
