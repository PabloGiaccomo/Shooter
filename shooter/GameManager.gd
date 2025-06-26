# GameManager.gd
extends Node2D

var score = 0

func _ready():
	reset_score()

func increase_score():
	score += 1
	update_score_ui()

func update_score_ui():
	var main_scene = get_tree().current_scene
	if main_scene.has_node("CanvasLayer/ScoreLabel"):
		main_scene.get_node("CanvasLayer/ScoreLabel").text = "Score: %d" % score

func reset_score():
	score = 0
	update_score_ui()
