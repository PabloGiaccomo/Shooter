extends Area2D

@onready var Zombie_Scene = load("res://zombie.tscn") 
var bool_spawn = true

var random = RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()

func _process(delta: float) -> void:
	spawn()
	
func spawn():
	if bool_spawn:
		$cooldown.start()
		bool_spawn = false
		var zombie_instance = Zombie_Scene.instantiate() # <--- Changed
		zombie_instance.position = Vector2(random.randi_range(30, 1000),random.randi_range(30, 600))
		add_child(zombie_instance)
		
func _on_cooldown_timeout() -> void:
	bool_spawn = true
