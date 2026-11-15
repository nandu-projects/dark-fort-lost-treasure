extends Area3D

var is_opened: bool = false
var player_in_range: bool = false

@onready var lid: Node3D = $LidPivot
@onready var chest_light: OmniLight3D = $LidPivot/TreasureLight
@onready var gold_particles: CPUParticles3D = $GoldParticles

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		_update_prompt()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		GameManager.hide_prompt()

func _update_prompt() -> void:
	if not player_in_range or is_opened:
		return
	if GameManager.has_treasure_key:
		GameManager.show_prompt("Press [E] to Unlock the Lost Treasure!")
	else:
		GameManager.show_prompt("The Chest is sealed with an ancient lock. You need the Ancient Key.")

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and not is_opened and event.is_action_pressed("interact"):
		if GameManager.has_treasure_key:
			open_chest()
		else:
			_update_prompt()

func open_chest() -> void:
	if is_opened:
		return
	is_opened = true
	GameManager.hide_prompt()
	
	if lid:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(lid, "rotation:x", -1.8, 1.2)
	
	if chest_light:
		chest_light.visible = true
	if gold_particles:
		gold_particles.emitting = true
	
	GameManager.win_game()
