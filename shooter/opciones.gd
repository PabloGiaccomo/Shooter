extends Control

func _on_continuar_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_reiniciar_pressed() -> void:
	GameManager.reset_score()
	get_tree().paused = false
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://world.tscn")

func _on_salir_pressed() -> void:
	get_tree().paused = false
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://MainMenu.tscn")
