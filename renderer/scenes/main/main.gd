extends Node2D

onready var artai = $ArtAI
onready var controls_container = $Controls

onready var fps_label = $Controls/VBox/FPSLabel

onready var fish_eye_switch = $Controls/VBox/FishEyeSwitch
onready var clip_switch = $Controls/VBox/ClipSwitch

onready var aperture_label = $Controls/VBox/ApertureLabel
onready var aperture_slider = $Controls/VBox/ApertureSlider

onready var zoom_label = $Controls/VBox/ZoomLabel
onready var zoom_slider = $Controls/VBox/ZoomSlider

onready var rotation_label = $Controls/VBox/RotationLabel
onready var rotation_slider = $Controls/VBox/RotationSlider

onready var offset_x_slider = $Controls/VBox/OffsetXSlider
onready var offset_y_slider = $Controls/VBox/OffsetYSlider

onready var color_picker = $Controls/VBox/ColorPicker

func _ready() -> void:
    Globals.load_config()

    color_picker.color = Globals.background_color
    aperture_slider.value = Globals.aperture
    zoom_slider.value = Globals.zoom
    clip_switch.pressed = Globals.clip

func _process(delta: float) -> void:
    controls_container.visible = Globals.controls_visible

    Globals.background_color = color_picker.color
    VisualServer.set_default_clear_color(Globals.background_color)

    fps_label.text = '%s FPS' % Engine.get_frames_per_second()

    Globals.fish_eye = fish_eye_switch.pressed
    Globals.clip = clip_switch.pressed

    aperture_label.text = 'Aperture (%s)' % aperture_slider.value
    Globals.aperture = aperture_slider.value

    zoom_label.text = 'Zoom (%s)' % zoom_slider.value
    Globals.zoom = zoom_slider.value

    rotation_label.text = 'Rotation (%s)' % rotation_slider.value
    Globals.rotation = rotation_slider.value

    artai.scale = Vector2(Globals.zoom, Globals.zoom)
    artai.position = Vector2(
        offset_x_slider.value * 1920 + 1920 / 2,
        offset_y_slider.value * 1080 + 1080 / 2
    )
    artai.rotation = deg2rad(Globals.rotation)

func _unhandled_input(event: InputEvent) -> void:
    if Input.is_action_just_pressed("ui_toggle_controls"):
        Globals.controls_visible = not Globals.controls_visible

func _on_save() -> void:
    Globals.save_config()
