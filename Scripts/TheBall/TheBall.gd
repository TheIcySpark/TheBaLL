extends RigidBody2D


export var impulso_carga : float
export var velocidad_angular_giro : float
export var maxima_carga_disparo : float
export var multiplicador_carga_disparo : float
export var velocidad_carga : float
export var velocidad_descarga : float

onready var UI_control : Control = $UITheBall

var _cargando : bool = false
var _carga_actual_disparo : float


func _physics_process(delta: float) -> void:
	_leer_input()
	if _cargando:
		UI_control.agregar_carga_disparo(velocidad_descarga)
		if UI_control.get_carga_disparo() > 0:
			_carga_actual_disparo = min(_carga_actual_disparo + 0.1 , 
			maxima_carga_disparo)
	elif not _cargando:
		UI_control.agregar_carga_disparo(velocidad_carga)


func _leer_input():
	if Input.is_action_just_pressed("ui_cargar"):
		if _cargando:
			_disparar()
		elif not _cargando:
			_iniciar_cargado()
		_cargando = !_cargando
	if Input.is_action_just_pressed("ui_girar_derecha") and _cargando:
		if angular_velocity >= 0:
			angular_velocity += velocidad_angular_giro
		else:
			angular_velocity = 0
	if Input.is_action_just_pressed("ui_girar_izquierda") and _cargando:
		if angular_velocity <= 0:
			angular_velocity -= velocidad_angular_giro
		else:
			angular_velocity = 0

func _disparar():
	var radianes : float = rotation
	var direccion : Vector2 = Vector2.RIGHT.rotated(radianes)
	print(radianes)
	print(direccion)
	apply_central_impulse(direccion * _carga_actual_disparo 
			* multiplicador_carga_disparo)
	_carga_actual_disparo = 0

func _iniciar_cargado():
	apply_central_impulse(Vector2.UP * impulso_carga)



