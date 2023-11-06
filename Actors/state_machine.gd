extends Node

class_name StateMachine

#
# inner State class
#

enum {INVALID}

class State:

	var state_id: int:
		get = get_id, set = set_id

	var state_name: String:
		get = get_state_name, set = set_state_name

	func _init(id: int, state_name_: String) -> void:
		set_id(id)
		set_state_name(state_name_)

	func set_state_name(state_name_: String) -> void:
		state_name = state_name_

	func get_state_name() -> String:
		return state_name

	func set_id(state: int) -> void:
		state_id = state

	func get_id() -> int:
		return state_id

	func enter() -> void:
		pass

	func exit() -> void:
		pass

	func tick(_delta: float) -> void:
		pass

	func physics_tick(_delta: float) -> void:
		pass

	func input(_event) -> void:
		pass

	func get_transition() -> int:
		return INVALID

	func is_valid() -> bool:
		return state_id != INVALID

#
# end of State class
#

var states: Dictionary = {}:
	set(incoming_states):
		states = incoming_states
		for incoming_state in states.values():
			var array_size = states.values().filter(
				func(saved_state):
					return saved_state.state_id == incoming_state.state_id
			).size()
			Util.crash_if_false(
				array_size <= 1,
				"Duplicated states in the incoming states found"
			)

var active_state: State = null

func _init(default_state: int = INVALID, states_list: Dictionary = {}) -> void:
	states = states_list
	active_state = get_state_by_id(default_state) if default_state != INVALID else null

func _ready():
	if active_state == null:
		return
	active_state.enter()

func _process(delta):
	if active_state == null:
		return

	var transition_state: int = active_state.get_transition()
	if transition_state != INVALID:
		var found_state: State = get_state_by_id(transition_state)
		if found_state.is_valid():
			active_state.exit()
			active_state = found_state
			active_state.enter()

	active_state.tick(delta)

func _physics_process(delta):
	if active_state == null:
		return

	active_state.physics_tick(delta)

func _unhandled_input(event):
	if active_state == null:
		return

	active_state.input(event)

func add_state(state: State) -> void:
	# sanitize the added state
	Util.crash_if_false(
		state not in states,
		"Duplicated states in the state machine found"
	)
	states[state.state_id] = state

func get_state_by_id(state_id: int) -> State:
	assert(states.has(state_id), "State {0} not present in state machine".format([state_id]))
	return states[state_id]
