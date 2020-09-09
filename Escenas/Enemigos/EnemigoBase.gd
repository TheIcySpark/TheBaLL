extends KinematicBody2D

export var velocidad: float
onready var jugador: RigidBody2D = get_parent().get_parent().get_node("Jugador")

func _segur_jugador() -> void:
	if jugador == null: return
	var posicion_jugador = jugador.position
	move_and_collide(position.direction_to(posicion_jugador) * velocidad)
	rotation = position.angle_to_point(jugador.position)


func _process(delta: float) -> void:
	_segur_jugador()


func _on_Area_body_entered(body: Node) -> void:
	if body == jugador:
		jugador.muerte()






