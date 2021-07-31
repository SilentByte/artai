extends Node2D

onready var empty_material = preload("res://scenes/artai/materials/empty.tres")
onready var fish_eye_material = preload("res://scenes/artai/materials/fish_eye.tres")


func _process(_delta: float) -> void:
	if Globals.fish_eye:
		$Content.set_material(fish_eye_material)
		$Content.get_material().set_shader_param("clip", Globals.clip)
		$Content.get_material().set_shader_param("aperture", Globals.aperture)
	else:
		$Content.set_material(empty_material)
