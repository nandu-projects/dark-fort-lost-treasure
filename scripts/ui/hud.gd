extends Control

@onready var health_bar: ProgressBar = $TopBar/HealthContainer/HealthBar
@onready var health_label: Label = $TopBar/HealthContainer/HealthLabel
@onready var objective_label: Label = $TopBar/ObjectiveContainer/ObjectiveLabel
@onready var key_badge: PanelContainer = $TopBar/KeyBadge
@onready var prompt_panel: PanelContainer = $CenterPrompt
@onready var prompt_label: Label = $CenterPrompt/PromptLabel
@onready var damage_flash: ColorRect = $DamageFlash

var _last_hp: int = 100

func _ready() -> void:
	if GameManager:
		GameManager.health_changed.connect(_on_health_changed)
		GameManager.objective_updated.connect(_on_objective_updated)
		GameManager.key_collected.connect(_on_key_collected)
		GameManager.interact_prompt_changed.connect(_on_prompt_changed)
	
	prompt_panel.visible = false
	key_badge.visible = false
	damage_flash.modulate.a = 0.0

func _on_health_changed(current: int, max_hp: int) -> void:
	health_bar.max_value = max_hp
	health_bar.value = current
	health_label.text = "HP: %d / %d" % [current, max_hp]
	
	if current < _last_hp:
		_flash_damage()
	_last_hp = current

func _flash_damage() -> void:
	var tween = create_tween()
	damage_flash.modulate.a = 0.4
	tween.tween_property(damage_flash, "modulate:a", 0.0, 0.4)

func _on_objective_updated(text: String) -> void:
	objective_label.text = "Objective: " + text
	# Subtle pop animation on objective update
	var tween = create_tween()
	objective_label.scale = Vector2(1.08, 1.08)
	tween.tween_property(objective_label, "scale", Vector2.ONE, 0.3)

func _on_key_collected(_key_name: String) -> void:
	key_badge.visible = true
	var tween = create_tween()
	key_badge.scale = Vector2(1.3, 1.3)
	tween.tween_property(key_badge, "scale", Vector2.ONE, 0.3)

func _on_prompt_changed(text: String, is_visible: bool) -> void:
	prompt_label.text = text
	prompt_panel.visible = is_visible
