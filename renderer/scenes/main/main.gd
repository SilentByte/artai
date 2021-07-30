extends Node2D

onready var artai = $ArtAI

onready var fps_label = $MarginContainer/VBoxContainer/FPSLabel

onready var fish_eye_switch = $MarginContainer/VBoxContainer/FishEyeSwitch
onready var clip_switch = $MarginContainer/VBoxContainer/ClipSwitch

onready var aperture_label = $MarginContainer/VBoxContainer/ApertureLabel
onready var aperture_slider = $MarginContainer/VBoxContainer/ApertureSlider

onready var zoom_label = $MarginContainer/VBoxContainer/ZoomLabel
onready var zoom_slider = $MarginContainer/VBoxContainer/ZoomSlider

onready var offset_x_slider = $MarginContainer/VBoxContainer/OffsetXSlider
onready var offset_y_slider = $MarginContainer/VBoxContainer/OffsetYSlider

func _ready() -> void:
    aperture_slider.value = Globals.aperture
    zoom_slider.value = Globals.zoom
    clip_switch.pressed = Globals.clip

func _process(delta: float) -> void:
    fps_label.text = '%s FPS' % Engine.get_frames_per_second()

    Globals.fish_eye = fish_eye_switch.pressed
    Globals.clip = clip_switch.pressed

    aperture_label.text = 'Aperture (%s)' % aperture_slider.value
    Globals.aperture = aperture_slider.value

    zoom_label.text = 'Zoom (%s)' % zoom_slider.value
    Globals.zoom = zoom_slider.value

    artai.scale = Vector2(Globals.zoom, Globals.zoom)
    artai.position = Vector2(
        offset_x_slider.value * 1920 + 1920 / 2,
        offset_y_slider.value * 1080 + 1080 / 2
    )
