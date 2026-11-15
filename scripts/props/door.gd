extends Node3D

@export var open_height: float = 4.5
@export var open_duration: float = 2.5

@onready var gate_mesh: Node3D = $GateModel
var is_open: bool = false
var player_in_range: bool = false

func _ready() -> void:
	if GameManager:
		GameManager.puzzle_solved.connect(open_gate)
	var area = $InteractArea
	if area:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)

func open_gate() -> void:
	if is_open:
		return
	is_open = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(gate_mesh, "position:y", open_height, open_duration)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		if not is_open:
			GameManager.show_prompt("Heavy Portcullis is sealed. Activate 3 Rune Pillars to unseal it.")

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		GameManager.hide_prompt()
