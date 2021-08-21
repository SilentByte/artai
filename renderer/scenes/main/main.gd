extends Node2D

onready var artai = $ArtAI
onready var controls_container = $Controls

onready var fps_label = $Controls/VBox/HeaderHBox/FPSLabel

onready var fish_eye_switch = $Controls/VBox/FishEyeSwitch
onready var clip_switch = $Controls/VBox/ClipSwitch

onready var aperture_label = $Controls/VBox/ApertureLabel
onready var aperture_slider = $Controls/VBox/ApertureSlider

onready var zoom_label = $Controls/VBox/ZoomLabel
onready var zoom_slider = $Controls/VBox/ZoomSlider

onready var rotation_label = $Controls/VBox/RotationLabel
onready var rotation_slider = $Controls/VBox/RotationSlider

onready var offset_x_label = $Controls/VBox/OffsetXLabel
onready var offset_x_slider = $Controls/VBox/OffsetXSlider

onready var offset_y_label = $Controls/VBox/OffsetYLabel
onready var offset_y_slider = $Controls/VBox/OffsetYSlider

onready var color_label = $Controls/VBox/ColorLabel
onready var color_picker = $Controls/VBox/ColorPicker

onready var volume_label = $Controls/VBox/VolumeLabel
onready var volume_slider = $Controls/VBox/VolumeSlider

onready var art_dir_label = $Controls/VBox/ArtDirLabel
onready var art_dir_line_edit = $Controls/VBox/ArtDirLineEdit


func _ready() -> void:
	Globals.load_config()
	_reset()


func _reset() -> void:
	fish_eye_switch.pressed = Globals.fish_eye
	clip_switch.pressed = Globals.clip
	aperture_slider.value = Globals.aperture
	zoom_slider.value = Globals.zoom
	rotation_slider.value = Globals.rotation
	offset_x_slider.value = Globals.offset_x
	offset_y_slider.value = Globals.offset_y
	color_picker.color = Globals.background_color
	volume_slider.value = Globals.volume_db
	art_dir_line_edit.text = Globals.art_dir


func _process(_delta: float) -> void:
	controls_container.visible = Globals.controls_visible

	fps_label.text = "%s FPS" % Engine.get_frames_per_second()

	Globals.fish_eye = fish_eye_switch.pressed
	Globals.clip = clip_switch.pressed

	aperture_label.text = "Aperture (%d°)" % aperture_slider.value
	Globals.aperture = aperture_slider.value

	zoom_label.text = "Zoom (%.2f)" % zoom_slider.value
	Globals.zoom = zoom_slider.value
	artai.scale = Vector2(Globals.zoom, Globals.zoom)

	offset_x_label.text = "Offset X (%.2f)" % offset_x_slider.value
	Globals.offset_x = offset_x_slider.value

	offset_y_label.text = "Offset Y (%.2f)" % offset_y_slider.value
	Globals.offset_y = offset_y_slider.value

	artai.position = Vector2(Globals.offset_x * 1920 + 1920 / 2, Globals.offset_y * 1080 + 1080 / 2)

	rotation_label.text = "Rotation (%.2f)" % rotation_slider.value
	Globals.rotation = rotation_slider.value
	artai.rotation_degrees = Globals.rotation

	color_label.text = "Background #(%s)" % color_picker.color.to_html(false)
	Globals.background_color = color_picker.color
	VisualServer.set_default_clear_color(Globals.background_color)

	volume_label.text = "Volume (%.2fdb)" % volume_slider.value
	Globals.volume_db = volume_slider.value

	Globals.art_dir = art_dir_line_edit.text


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().quit()
		return

	if Input.is_action_just_pressed("ui_toggle_controls"):
		Globals.controls_visible = not Globals.controls_visible
		return

	if Input.is_action_just_pressed("ui_toggle_full_screen"):
		OS.window_borderless = ! OS.window_borderless
		OS.window_maximized = ! OS.window_maximized
		OS.set_window_size(OS.get_screen_size())


func _on_save() -> void:
	Globals.save_config()


func _on_reset() -> void:
	Globals.reset_config()
	Globals.save_config()

	_reset()
