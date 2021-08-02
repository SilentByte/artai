extends Reference

class_name SpectrumAnalyzer

var _peak = 0.0
var _volume = 0.0

func analyze(current_volume_db: float) -> float:
	var current_volume = db2linear(current_volume_db)

	_peak = lerp(_peak, current_volume, 0.1)
	_volume = lerp(_volume, current_volume, 0.5)

	return abs(_peak - _volume) / abs(_peak)
