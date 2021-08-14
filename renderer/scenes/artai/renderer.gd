extends Node2D

onready var item_scene = preload("res://scenes/artai/render_item.tscn")
onready var content = $Content
onready var audio_spectrum = $AudioSpectrum
onready var timer = $Timer

var spectrum_analyzer = SpectrumAnalyzer.new()


func _ready() -> void:
	if get_tree().get_current_scene().get_name() == "Renderer":
		$DebugCamera.current = true

	_add_item()
	_add_item()
	_add_item()

	timer.start()


func _add_item() -> void:
	var item = item_scene.instance()

	item.position = Vector2(1024, 1024)
	item.position.x += rand_range(-256, 256)
	item.position.y += rand_range(-256, 256)
	item.rotation_degrees += rand_range(-180, 180)
	item.texture = Curator.next().texture
	item.scale = Vector2(1024 / item.texture.get_width(), 1024 / item.texture.get_height())

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

func _process(delta: float) -> void:
	var peak_volume = AudioServer.get_bus_peak_volume_left_db(0, 0)
	var amplitude = spectrum_analyzer.analyze(peak_volume)

	audio_spectrum.material.set_shader_param("amplitude", amplitude)


func _on_timeout() -> void:
	_add_item()
