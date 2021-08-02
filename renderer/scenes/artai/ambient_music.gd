extends AudioStreamPlayer

export(Array, AudioStreamMP3) var play_list = []


func _ready() -> void:
	play_random()


func play_random() -> void:
	if play_list.empty():
		return

	stream = play_list[int(rand_range(0, len(play_list) - 1))]
	play()


func _on_finished() -> void:
	play_random()


func _process(_delta: float) -> void:
	volume_db = Globals.volume_db
