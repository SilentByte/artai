extends Node

const DEFAULT_ART_DIR = "res://gfx/default_art/"
var _default_art_file_names: PoolStringArray


func _ready() -> void:
	_default_art_file_names = _list_default_art_file_names()


func _list_default_art_file_names() -> PoolStringArray:
	var dir = Directory.new()
	dir.open(DEFAULT_ART_DIR)
	dir.list_dir_begin()

	var file_names = PoolStringArray()
	while true:
		var file_name = dir.get_next()
		if not file_name:
			break

		if file_name.ends_with(".jpg"):
			file_names.append(DEFAULT_ART_DIR + file_name)

	dir.list_dir_end()

	return file_names


func _random_default_art() -> CuratorItem:
	var file_name = _default_art_file_names[int(rand_range(0, len(_default_art_file_names) - 1))]
	return CuratorItem.new("ArtAI", "", load(file_name))


func next() -> CuratorItem:
	return _random_default_art()
