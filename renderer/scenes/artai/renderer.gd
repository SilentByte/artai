extends Node2D

onready var item_scene = preload("res://scenes/artai/render_item.tscn")
onready var content = $Content


func _ready() -> void:
	if get_tree().get_current_scene().get_name() == "Renderer":
		$DebugCamera.current = true

	# TODO: IMPLEMENT.
	for i in range(10000):
		_add_item()
		yield(get_tree().create_timer(5), "timeout")


func _add_item() -> void:
	var item = item_scene.instance()

	item.position = Vector2(1024, 1024)
	item.position.x += rand_range(-256, 256)
	item.position.y += rand_range(-256, 256)
	item.rotation_degrees += rand_range(-180, 180)
	item.scale = Vector2(1.5, 1.5)
	item.texture = Curator.next().texture

	var item_ttl = rand_range(20, 40)
	var item_movement = Vector2(rand_range(-64, 64), rand_range(-64, 64))
	var item_rotation = rand_range(-3, 3)
	var item_scale = rand_range(0.1, 0.5)
	var item_smooth_width_fraction = rand_range(1.0, 2.0)

	content.add_child(item)
	item.animate(
		item_ttl,
		item_movement,
		item_rotation,
		item_scale,
		item_smooth_width_fraction
	)
