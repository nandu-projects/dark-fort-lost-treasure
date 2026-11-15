extends Node

signal health_changed(current: int, max_hp: int)
signal objective_updated(text: String)
signal key_collected(key_name: String)
signal puzzle_solved()
signal game_won()
signal player_died()
signal interact_prompt_changed(text: String, visible: bool)

var max_health: int = 100
var current_health: int = 100
var has_treasure_key: bool = false
var puzzle_completed: bool = false
var required_runes: Array[int] = [1, 2, 3]
var active_runes: Array[int] = []

var is_game_over: bool = false
var is_victory: bool = false

func _ready() -> void:
	_setup_inputs()
	reset_game_state()

func reset_game_state() -> void:
	current_health = max_health
	has_treasure_key = false
	puzzle_completed = false
	active_runes.clear()
	is_game_over = false
	is_victory = false
	health_changed.emit(current_health, max_health)
	objective_updated.emit("Explore the courtyard and find a way into the underground vault.")

func _setup_inputs() -> void:
	var key_mappings = {
		"move_forward": [KEY_W, KEY_UP],
		"move_back": [KEY_S, KEY_DOWN],
		"move_left": [KEY_A, KEY_LEFT],
		"move_right": [KEY_D, KEY_RIGHT],
		"jump": [KEY_SPACE],
		"sprint": [KEY_SHIFT],
		"interact": [KEY_E],
		"pause": [KEY_ESCAPE]
	}
	
	for action_name in key_mappings:
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
		for key_code in key_mappings[action_name]:
			var event = InputEventKey.new()
			event.physical_keycode = key_code
			event.pressed = false
			# Check if event already exists
			var exists = false
			for ev in InputMap.action_get_events(action_name):
				if ev is InputEventKey and ev.physical_keycode == key_code:
					exists = true
					break
			if not exists:
				InputMap.action_add_event(action_name, event)

func take_damage(amount: int) -> void:
	if is_game_over or is_victory:
		return
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	if current_health <= 0:
		is_game_over = true
		player_died.emit()

func heal(amount: int) -> void:
	if is_game_over:
		return
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)

func collect_key() -> void:
	has_treasure_key = true
	key_collected.emit("Ancient Gold Key")
	objective_updated.emit("Key obtained! Locate the Treasure Vault deep in the catacombs.")

func activate_rune(rune_id: int) -> void:
	if puzzle_completed:
		return
	if not active_runes.has(rune_id):
		active_runes.append(rune_id)
		objective_updated.emit("Ancient Runes activated: %d of %d" % [active_runes.size(), required_runes.size()])
		if active_runes.size() >= required_runes.size():
			puzzle_completed = true
			puzzle_solved.emit()
			objective_updated.emit("The Portcullis unsealed! Enter the underground catacombs.")

func show_prompt(text: String) -> void:
	interact_prompt_changed.emit(text, true)

func hide_prompt() -> void:
	interact_prompt_changed.emit("", false)

func win_game() -> void:
	if is_victory:
		return
	is_victory = true
	game_won.emit()
