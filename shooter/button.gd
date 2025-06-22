extends Button

@onready var opciones_scene = preload("res://Opciones.tscn")

func _on_pressed() -> void:
	var opciones_instance = opciones_scene.instantiate()
	get_tree().get_current_scene().add_child(opciones_instance)
	await get_tree().process_frame  # Espera a que se muestre
	get_tree().paused = true
