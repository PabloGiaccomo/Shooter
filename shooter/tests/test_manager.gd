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
	game_manager._ready()

func after_each():
	# Limpiamos nodos al terminar cada test
	fake_scene.queue_free()
	game_manager.queue_free()
# --- TESTS ---

# --- TESTS Unitarios (TDD) ---
# --- TDD Test 1: increase_score() incrementa en 1 y UI se actualiza ---
func test_tdd_increase_score_one():
	game_manager.score = 0
	game_manager.increase_score()
	assert_eq(game_manager.score, 1, "TDD1: score debe ser 1")
	assert_eq(score_label.text, "Score: 1", "TDD1: UI debe mostrar Score: 1")

# --- TDD Test 2: reset_score() lleva score a 0 y UI se actualiza ---
func test_tdd_reset_score():
	game_manager.score = 5
	game_manager.reset_score()
	assert_eq(game_manager.score, 0, "TDD2: score debe resetear a 0")
	assert_eq(score_label.text, "Score: 0", "TDD2: UI debe mostrar Score: 0")

# --- TDD Test 3: increase_score() acumulativo ---
func test_tdd_accumulative_score():
	for i in range(3):
		game_manager.increase_score()
	assert_eq(game_manager.score, 3, "TDD3: score debe ser 3 después de 3 llamadas")

# --- TDD Test 4: reset_score() repetido sin errores ---
func test_tdd_reset_twice_does_not_error():
	game_manager.reset_score()
	game_manager.reset_score()
	assert_eq(game_manager.score, 0, "TDD4: reset de score en 0 no debe fallar")

# --- TDD Test 5: increase_score() no afecta si UI no existe ---
func test_tdd_increase_without_ui():
	score_label.queue_free()
	game_manager.increase_score()
	assert_eq(game_manager.score, 1, "TDD5: score incrementa aunque falte UI")

# --- TDD Test 6: llamar reset_score mantiene score 0 si ya era 0 ---
func test_tdd_reset_at_zero():
	game_manager.score = 0
	game_manager.reset_score()
	assert_eq(game_manager.score, 0, "TDD7: reset en cero no modifica el valor")

# --- TDD Test 7: llamar increase_score varias veces y reset luego ---
func test_tdd_multiple_then_reset():
	for i in range(3):
		game_manager.increase_score()
	game_manager.reset_score()
	assert_eq(game_manager.score, 0, "TDD8: score debe ser 0 después de múltiples aumentos y reset")
	
# --- TESTS de Comportamiento (BDD) ---
# --- BDD Test 1: dado puntaje inicial, cuando aumentas, entonces UI refleja ---
func test_bdd_should_show_score_after_increase():
	# Given
	game_manager.score = 0
	# When
	game_manager.increase_score()
	# Then
	assert_eq(score_label.text, "Score: 1", "BDD1: UI refleja aumento de puntaje")

# --- BDD Test 2: dado puntaje alto, cuando reseteas, entonces vuelve a cero ---
func test_bdd_should_reset_to_zero_from_high_score():
	game_manager.score = 10
	game_manager.reset_score()
	assert_eq(game_manager.score, 0, "BDD2: score vuelve a 0 desde 10")
	assert_eq(score_label.text, "Score: 0", "BDD2: UI resetea correctamente")

# --- BDD Test 3: dado múltiples aumentos, cuando revisas, entonces score correcto ---
func test_bdd_should_accumulate_score_properly():
	for i in range(4):
		game_manager.increase_score()
	assert_eq(game_manager.score, 4, "BDD3: score debe ser 4 después de 4 aumentos")

# --- BDD Test 4: dado UI removida, cuando aumentas puntaje, entonces no causa error ---
func test_bdd_should_not_error_without_ui():
	score_label.queue_free()
	game_manager.increase_score()
	assert_eq(game_manager.score, 1, "BDD4: score se incrementa sin UI sin errores")

# --- BDD Test 5: dado estado sin cambios, cuando reseteas, entonces score y UI en cero ---
func test_bdd_should_keep_zero_on_reset_initial_state():
	game_manager.score = 0
	game_manager.reset_score()
	assert_eq(game_manager.score, 0, "BDD5: score permanece 0")
	assert_eq(score_label.text, "Score: 0", "BDD5: UI muestra Score: 0")

# --- BDD Test 6: dado score en cero, cuando reset, entonces sigue en cero ---
func test_bdd_should_remain_zero_on_reset():
	game_manager.score = 0
	game_manager.reset_score()
	assert_eq(score_label.text, "Score: 0", "BDD7: UI permanece en Score: 0 tras reset")

# --- BDD Test 7: dado aumentos seguidos, cuando inspectas UI, entonces muestra valor acumulado ---
func test_bdd_should_show_correct_ui_after_multiple():
	for i in range(7):
		game_manager.increase_score()
	assert_eq(score_label.text, "Score: 7", "BDD8: UI muestra 'Score: 7' tras 7 aumentos")


# --- TESTS de Aceptación (ATDD) ---
# --- ATDD Test 1: usuario espera ver score en pantalla al iniciar partida ---
func test_atdd_initial_score_display():
	# Scenario: Al iniciar partida
	assert_eq(score_label.text, "Score: 0", "ATDD1: usuario ve Score: 0 al iniciar")

# --- ATDD Test 2: al marcar un punto, usuario ve la nueva puntuación ---
func test_atdd_increment_score_shows_to_user():
	game_manager.increase_score()
	assert_eq(score_label.text, "Score: 1", "ATDD2: usuario ve Score: 1 tras un punto")

# --- ATDD Test 3: al reiniciar partida, usuario ve que score vuelve a cero ---
func test_atdd_user_sees_zero_after_reset():
	game_manager.increase_score()
	game_manager.reset_score()
	assert_eq(score_label.text, "Score: 0", "ATDD3: usuario ve Score: 0 tras reinicio")

# --- ATDD Test 4: usuario no recibe errores si UI falla ---
func test_atdd_no_error_if_ui_missing():
	score_label.queue_free()
	game_manager.reset_score()
	assert_eq(game_manager.score, 0, "ATDD4: usuario no ve error y score es 0")

# --- ATDD Test 5: tras múltiples eventos, usuario ve score correcto final ---
func test_atdd_user_sees_cumulative_score():
	for i in range(2):
		game_manager.increase_score()
	for i in range(1):
		game_manager.reset_score()
	assert_eq(score_label.text, "Score: 0", "ATDD5: usuario ve score reiniciado correctamente")

# --- ATDD Test 6: usuario ve score válido tras muerte del jugador ---
func test_atdd_user_sees_zero_on_death():
	# Simular muerte > reinicio
	GameManager.reset_score()
	assert_eq(score_label.text, "Score: 0", "ATDD6: tras muerte, usuario ve Score: 0")

# --- ATDD Test 7: puntaje visible tras varias sesiones de juego ---
func test_atdd_user_sees_cumulative_after_sessions():
	game_manager.reset_score()
	for i in range(2):
		game_manager.increase_score()
	game_manager.reset_score()
	game_manager.increase_score()
	assert_eq(score_label.text, "Score: 1", "ATDD8: usuario ve Score: 1 después de múltiples sesiones")
	
