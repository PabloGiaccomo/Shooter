extends GutTest

var game_manager
var score_label
var fake_scene

func before_each():
	# Creamos una instancia del GameManager
	game_manager = preload("res://GameManager.gd").new()
	
	# Simulamos una escena principal con un CanvasLayer y un ScoreLabel
	score_label = Label.new()
	score_label.name = "ScoreLabel"

	var canvas_layer = CanvasLayer.new()
	canvas_layer.name = "CanvasLayer"
	canvas_layer.add_child(score_label)

	fake_scene = Node.new()
	fake_scene.add_child(canvas_layer)

	# Hacemos que GameManager tenga acceso a la escena falsa
	# Usamos un truco: agregamos GameManager al árbol para que get_tree() funcione
	add_child(game_manager)
	get_tree().root.add_child(fake_scene)
	get_tree().set_current_scene(fake_scene)


func after_each():
	# Limpiamos nodos al terminar cada test
	fake_scene.queue_free()
	game_manager.queue_free()

# --- TESTS ---

func test_increase_score_incrementa_y_actualiza_ui():
	game_manager.increase_score()
	assert_eq(game_manager.score, 1, "Score debe ser 1 después de aumentar")
	assert_eq(score_label.text, "Score: 1", "El UI debe mostrar 'Score: 1'")

func test_reset_score_vuelve_a_cero_y_actualiza_ui():
	game_manager.increase_score()  # para asegurarnos que no empieza en 0
	game_manager.reset_score()
	assert_eq(game_manager.score, 0, "Score debe volver a 0")
	assert_eq(score_label.text, "Score: 0", "El UI debe mostrar 'Score: 0'")
