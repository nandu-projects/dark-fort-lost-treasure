extends Area3D

@export var damage: int = 35
@export var active_time: float = 1.2
@export var warning_time: float = 0.6
@export var idle_time: float = 1.8

@onready var spikes: Node3D = $Spikes
@onready var warning_light: OmniLight3D = $WarningLight

var is_active: bool = false
var player_inside: bool = false
var _cycle_timer: float = 0.0

enum State { IDLE, WARNING, ACTIVE }
var current_state: State = State.IDLE

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_set_state(State.IDLE)

func _process(delta: float) -> void:
	_cycle_timer += delta
	match current_state:
		State.IDLE:
			if _cycle_timer >= idle_time:
				_set_state(State.WARNING)
		State.WARNING:
			# Subtle flicker on warning light
			if warning_light:
				warning_light.light_energy = 1.5 + sin(_cycle_timer * 20.0) * 0.8
			if _cycle_timer >= warning_time:
				_set_state(State.ACTIVE)
		State.ACTIVE:
			if _cycle_timer >= active_time:
				_set_state(State.IDLE)

func _set_state(new_state: State) -> void:
	current_state = new_state
	_cycle_timer = 0.0
	match current_state:
		State.IDLE:
			is_active = false
			if warning_light:
				warning_light.visible = false
			_animate_spikes(0.0)
		State.WARNING:
			is_active = false
			if warning_light:
				warning_light.visible = true
				warning_light.light_color = Color(1.0, 0.5, 0.1)
		State.ACTIVE:
			is_active = true
			if warning_light:
				warning_light.visible = true
				warning_light.light_color = Color(1.0, 0.1, 0.1)
			_animate_spikes(1.0)
			if player_inside:
				GameManager.take_damage(damage)

func _animate_spikes(target_y: float) -> void:
	if not spikes:
		return
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK if target_y > 0 else Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(spikes, "position:y", target_y, 0.15 if target_y > 0 else 0.4)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		if is_active:
			GameManager.take_damage(damage)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = false
