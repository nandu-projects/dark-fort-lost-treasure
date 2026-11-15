extends Control

@onready var restart_button: Button = $Panel/VBoxContainer/RestartButton
@onready var quit_button: Button = $Panel/VBoxContainer/QuitButton

func _ready() -> void:
	visible = false
	if GameManager:
		GameManager.game_won.connect(_on_game_won)
	
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_game_won() -> void:
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# Smooth fade-in
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.6)

func _on_restart_pressed() -> void:
	GameManager.reset_game_state()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
