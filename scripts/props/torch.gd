extends Node3D

@export var base_energy: float = 1.8
@export var flicker_intensity: float = 0.3
@export var flicker_speed: float = 10.0

@onready var omni_light: OmniLight3D = $OmniLight3D

var _time: float = 0.0
var _offset: float = 0.0

func _ready() -> void:
	_offset = randf() * 100.0

func _process(delta: float) -> void:
	if not omni_light:
		return
	_time += delta * flicker_speed
	var noise = sin(_time + _offset) * cos(_time * 1.7 + _offset)
	omni_light.light_energy = base_energy + (noise * flicker_intensity)
