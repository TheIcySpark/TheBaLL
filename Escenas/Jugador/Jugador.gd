extends RigidBody2D

export var velocidad_angular_giro : float
export var maxima_fuerza_disparo: float
export var velocidad_carga_energia: float
export var multiplicador_fuerza_disparo: float
export var cargando_disparo_damp: float

onready var carga_disparo : TextureProgress = $HUD/Control/CargaDisparo
onready var flecha: Sprite = $Sprite/Flecha

enum Estados{
	CARGANDO_DISPARO,
	CARGANDO_ENERGIA
}

var _estado_actual : int = Estados.CARGANDO_ENERGIA
var _fuerza_actual_disparo: float = 0

func _aumentar_energia(delta : float) -> void:
	carga_disparo.value += velocidad_carga_energia * delta



func _aumentar_fuerza_disparo(delta : float) -> void:
	if carga_disparo.value > 0:
		carga_disparo.value -= velocidad_carga_energia * delta
		_fuerza_actual_disparo = min(maxima_fuerza_disparo , 
				_fuerza_actual_disparo + velocidad_carga_energia * delta)
	flecha.aparecer_flecha(_fuerza_actual_disparo , maxima_fuerza_disparo)


func _disparar():
	var radianes = rotation
	var direccion = Vector2.RIGHT.rotated(radianes).normalized()
	apply_central_impulse(direccion * _fuerza_actual_disparo * 
			multiplicador_fuerza_disparo)
	_fuerza_actual_disparo = 0
	flecha.aparecer_flecha(_fuerza_actual_disparo , maxima_fuerza_disparo)


func _cambio_estado(estado_anterior : int, estado_nuevo: int) -> void:
	_estado_actual = estado_nuevo
	match estado_anterior:
		Estados.CARGANDO_DISPARO:
			pass
		Estados.CARGANDO_ENERGIA:
			pass
	match estado_nuevo:
		Estados.CARGANDO_DISPARO:
			angular_damp = 0
			angular_velocity = 0
			linear_damp = cargando_disparo_damp
		Estados.CARGANDO_ENERGIA:
			angular_damp = -1
			linear_damp = -1


func _process(delta: float) -> void:
	match _estado_actual:
		Estados.CARGANDO_DISPARO:
			_aumentar_fuerza_disparo(delta)
		Estados.CARGANDO_ENERGIA:
			_aumentar_energia(delta)


func _unhandled_input(event: InputEvent) -> void:
	match _estado_actual:
		Estados.CARGANDO_DISPARO:
			if Input.is_action_pressed("ui_derecha"):
				if angular_velocity < velocidad_angular_giro:
					angular_velocity += velocidad_angular_giro
			elif Input.is_action_pressed("ui_izquierda"):
				if angular_velocity > -velocidad_angular_giro:
					angular_velocity -= velocidad_angular_giro
			elif event.is_action_pressed("ui_cargar"):
				_cambio_estado(Estados.CARGANDO_DISPARO , Estados.CARGANDO_ENERGIA)
			elif event.is_action_pressed("ui_disparar"):
				_disparar()
				_cambio_estado(Estados.CARGANDO_DISPARO , Estados.CARGANDO_ENERGIA)
		Estados.CARGANDO_ENERGIA:
			if event.is_action_pressed("ui_cargar"):
				_cambio_estado(Estados.CARGANDO_ENERGIA , Estados.CARGANDO_DISPARO)






