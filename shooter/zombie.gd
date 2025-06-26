extends CharacterBody2D

@onready var ray_cast_2d = $RayCast2D

@export var move_speed = 50
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")

var dead = false

func _ready():
	GameManager.speed_level_changed.connect(_on_speed_level_changed)


func _on_speed_level_changed(new_level):
	move_speed = 50 + (new_level * 200)
	
func _physics_process(delta):
	if dead:
		return
	
	var dir_to_player = global_position.direction_to(player.global_position)
	velocity = dir_to_player * move_speed
	move_and_slide()
	
	global_rotation = dir_to_player.angle() + PI/2.0
	
	if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider() == player:
		player.kill()

func kill():
	if dead:
		return
	dead = true
	$DeadSound.play()
	$Graphics/Dead.show()
	$Graphics/Alive.hide()
	$CollisionShape2D.disabled = true
	z_index = -1
	GameManager.increase_score()
