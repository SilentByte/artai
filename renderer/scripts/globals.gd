extends Node

const TITLE = "Art愛"
const CONFIG_FILE_NAME = ".artai_config"

var controls_visible = true
var background_color = Color.black
var fish_eye = true
var clip = true
var aperture = 180.0
var zoom = 1.0
var rotation = 0.0
var offset_x = 0.0
var offset_y = 0.0

func reset_config() -> void:
    controls_visible = true
    background_color = Color.black
    fish_eye = true
    clip = true
    aperture = 180.0
    zoom = 1.0
    rotation = 0.0
    offset_x = 0.0
    offset_y = 0.0

func save_config() -> void:
    var config = {
        "controls_visible": controls_visible,
        "background_color": background_color,
        "fish_eye": fish_eye,
        "clip": clip,
        "aperture": aperture,
        "zoom": zoom,
        "rotation": rotation,
        "offset_x": offset_x,
        "offset_y": offset_y,
    }

    var file = File.new()
    file.open(CONFIG_FILE_NAME, File.WRITE)
    file.store_var(config)
    file.close()

func load_config() -> void:
    var config = {}
    var file = File.new()
    if file.file_exists(CONFIG_FILE_NAME):
        file.open(CONFIG_FILE_NAME, File.READ)
        config = file.get_var()
        file.close()

    reset_config()
    controls_visible = config.get("controls_visible", controls_visible)
    background_color = config.get("background_color", background_color)
    fish_eye = config.get("fish_eye", fish_eye)
    clip = config.get("clip", clip)
    aperture = config.get("aperture", aperture)
    zoom = config.get("zoom", zoom)
    rotation = config.get("rotation", rotation)
    offset_x = config.get("offset_x", offset_x)
    offset_y = config.get("offset_y", offset_y)
