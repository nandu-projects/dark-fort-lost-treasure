extends Area3D

var player_in_range: bool = false
var _time: float = 0.0

@onready var mesh: Node3D = $MeshHolder

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	_time += delta
	if mesh:
		mesh.rotate_y(delta * 2.0)
		mesh.position.y = sin(_time * 3.0) * 0.15

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		GameManager.show_prompt("Press [E] to collect the Ancient Vault Key")

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		GameManager.hide_prompt()

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		GameManager.collect_key()
		GameManager.hide_prompt()
		queue_free()
