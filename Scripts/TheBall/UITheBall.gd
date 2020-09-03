extends Control

onready var _carga_disparo : TextureProgress = $UI/CargaDisparo
	
func agregar_carga_disparo(value : float) -> void:
		_carga_disparo.value += value

func get_carga_disparo() -> float:
	return _carga_disparo.value
