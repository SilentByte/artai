extends Node

const QUERY_ENDPOINT_URL = "http://127.0.0.1:8000/jobs"
const QUERY_INTERVAL = 2.0
const CURATION_SIZE = 20

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

var _client: HTTPRequest = null
var _query_timer: Timer = null
var _can_request = true

var _curated_items = []


func _ready() -> void:
	_client = HTTPRequest.new()
	_client.connect("request_completed", self, "_on_request_completed")
	add_child(_client)

	_query_timer = Timer.new()
	_query_timer.autostart = true
	_query_timer.wait_time = QUERY_INTERVAL
	_query_timer.connect("timeout", self, "_on_query_timer_timeout")
	add_child(_query_timer)

	for i in range(CURATION_SIZE):
		_curated_items.append(_random_default_art())


func _file_name_from_id(id: String) -> String:
	return '%s/%s.png' % [Globals.art_dir.trim_suffix("/"), id]


func _random_default_art() -> CuratorItem:
	var file_name = _default_art_textures[int(rand_range(0, len(_default_art_textures) - 1))]
	return CuratorItem.new(file_name, "ArtAI", "", load(file_name))


func _check_has_id(id: String) -> bool:
	for ci in _curated_items:
		if ci.id == id:
			return true

	return false

func _query() -> void:
	if not _can_request:
		print("Skipping query (busy)...")
		return

	_can_request = false

	var error = _client.request(
		QUERY_ENDPOINT_URL,
		["Content-Type: application/json"],
		true,
		HTTPClient.METHOD_GET,
		JSON.print({
			"limit": 10,
			"completed": true,
		})
	)

	if error != OK:
		push_error("Query failed: %s" % error)


func _on_request_completed(result, response_code, headers, body) -> void:
	_can_request = true

	if response_code < 200 or response_code > 299:
		push_error("Query response indicated error: %s" % response_code)
		return

	var data = parse_json(body.get_string_from_utf8())
	if not data:
		push_error("Query response is malformed")
		return

	if not data is Array:
		push_error("Query data is malformed, array expected")
		return

	# Ensure that the most recent art piece ends up on top.
	data.invert()

	for d in data:
		var id = d.get("id")

		if _check_has_id(id):
			continue

		var file_name = _file_name_from_id(id)
		var image = Image.new()

		if image.load(file_name) != OK:
			push_error("Could not load image from %s; ensure absolute path is specified" % file_name)
			continue

		var texture = ImageTexture.new()
		texture.create_from_image(image)

		_curated_items.push_front(CuratorItem.new(
			id,
			d.get("author"),
			d.get("prompt"),
			texture
		))

	_curated_items.resize(CURATION_SIZE)


func _on_query_timer_timeout() -> void:
	_query()


func next() -> CuratorItem:
	var item = _curated_items.pop_front()
	_curated_items.push_back(item)

	return item
