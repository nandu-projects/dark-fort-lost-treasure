extends Control

@onready var retry_button: Button = $Panel/VBoxContainer/RetryButton
@onready var quit_button: Button = $Panel/VBoxContainer/QuitButton

func _ready() -> void:
	visible = false
	if GameManager:
		GameManager.player_died.connect(_on_player_died)
	
	retry_button.pressed.connect(_on_retry_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_player_died() -> void:
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

func _on_retry_pressed() -> void:
	GameManager.reset_game_state()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
