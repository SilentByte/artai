extends Node2D

onready var empty_material = preload("res://scenes/artai/materials/empty.tres")
onready var fish_eye_material = preload("res://scenes/artai/materials/fish_eye.tres")
onready var canvas = $Canvas


func _ready() -> void:
	_change_texture()


func _process(_delta: float) -> void:
	if Globals.fish_eye:
		canvas.set_material(fish_eye_material)
		canvas.get_material().set_shader_param("clip", Globals.clip)
		canvas.get_material().set_shader_param("aperture", Globals.aperture)
	else:
		canvas.set_material(empty_material)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_force_next"):
		_change_texture()


func _change_texture() -> void:
	var item = Curator.next()
	var texture_scale = item.texture.get_width() / 256

	canvas.texture = item.texture
	canvas.scale = Vector2(texture_scale, texture_scale)
