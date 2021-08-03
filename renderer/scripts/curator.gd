extends Node

var _default_art_textures = [
	"res://gfx/default_art/01.jpg",
	"res://gfx/default_art/02.jpg",
	"res://gfx/default_art/03.jpg",
	"res://gfx/default_art/04.jpg",
	"res://gfx/default_art/05.jpg",
	"res://gfx/default_art/06.jpg",
	"res://gfx/default_art/07.jpg",
	"res://gfx/default_art/08.jpg",
	"res://gfx/default_art/09.jpg",
	"res://gfx/default_art/10.jpg",
	"res://gfx/default_art/11.jpg",
	"res://gfx/default_art/12.jpg",
	"res://gfx/default_art/13.jpg",
	"res://gfx/default_art/14.jpg",
	"res://gfx/default_art/15.jpg",
	"res://gfx/default_art/16.jpg",
	"res://gfx/default_art/17.jpg",
	"res://gfx/default_art/18.jpg",
	"res://gfx/default_art/19.jpg",
	"res://gfx/default_art/20.jpg",
	"res://gfx/default_art/21.jpg",
	"res://gfx/default_art/22.jpg",
	"res://gfx/default_art/23.jpg",
	"res://gfx/default_art/24.jpg",
	"res://gfx/default_art/25.jpg",
	"res://gfx/default_art/26.jpg",
	"res://gfx/default_art/27.jpg",
	"res://gfx/default_art/28.jpg",
	"res://gfx/default_art/29.jpg",
	"res://gfx/default_art/30.jpg",
	"res://gfx/default_art/31.jpg",
	"res://gfx/default_art/32.jpg",
]


func _random_default_art() -> CuratorItem:
	var file_name = _default_art_textures[int(rand_range(0, len(_default_art_textures) - 1))]
	return CuratorItem.new("ArtAI", "", load(file_name))


func next() -> CuratorItem:
	return _random_default_art()
