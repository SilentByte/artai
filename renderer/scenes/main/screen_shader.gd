extends ColorRect

var _spectrum_analyzer = SpectrumAnalyzer.new()

func _process(_delta: float) -> void:
	var peak_volume = AudioServer.get_bus_peak_volume_left_db(0, 0)
	var amplitude = _spectrum_analyzer.analyze(peak_volume)

	material.set_shader_param("shake_enabled", true)
	material.set_shader_param("shake_power", amplitude / 100)
