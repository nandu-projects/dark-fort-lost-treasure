extends Area3D

@export var pillar_id: int = 1
@export var rune_name: String = "Sun"

var is_active: bool = false
var player_in_range: bool = false

@onready var rune_gem: MeshInstance3D = $RuneGem
@onready var rune_light: OmniLight3D = $RuneLight
var mat_off = preload("res://materials/mat_rune_off.tres")
var mat_on = preload("res://materials/mat_rune_on.tres")

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_update_visuals()

func _update_visuals() -> void:
	if rune_gem:
		rune_gem.material_override = mat_on if is_active else mat_off
	if rune_light:
		rune_light.visible = is_active

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		_update_prompt()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		GameManager.hide_prompt()

func _update_prompt() -> void:
	if not player_in_range:
		return
	if is_active:
		GameManager.show_prompt("Ancient %s Rune is already active." % rune_name)
	else:
		GameManager.show_prompt("Press [E] to channel the %s Rune" % rune_name)

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and not is_active and event.is_action_pressed("interact"):
		activate()

func activate() -> void:
	if is_active:
		return
	is_active = true
	_update_visuals()
	GameManager.activate_rune(pillar_id)
	_update_prompt()
