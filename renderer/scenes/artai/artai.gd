extends Node2D

onready var empty_material = preload("res://scenes/artai/materials/empty.tres")
onready var fish_eye_material = preload("res://scenes/artai/materials/fish_eye.tres")
onready var canvas = $Canvas
onready var output = $Output


func _ready() -> void:
	output.texture = canvas.get_texture()
	output.scale = Vector2(
		output.texture.get_width() / 4096.0,
		output.texture.get_width() / 4096.0
	)
	_change_texture()


func _process(_delta: float) -> void:
	if Globals.fish_eye:
		output.material = fish_eye_material
		output.material.set_shader_param("clip", Globals.clip)
		output.material.set_shader_param("aperture", Globals.aperture)
	else:
		output.material = empty_material


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_force_next"):
		_change_texture()


func _change_texture() -> void:
	pass
