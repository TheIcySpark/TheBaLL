extends Sprite

func aparecer_flecha(
fuerza_disparo_actual: float ,
maxima_fuerza_disparo: float) -> void:
	material.set_shader_param("alpha" , fuerza_disparo_actual
			 / maxima_fuerza_disparo)
