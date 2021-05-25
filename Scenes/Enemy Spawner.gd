extends Area2D

onready var viewport = get_viewport().get_visible_rect().size

var size := Vector2()
export (Array, PackedScene) var enemies
var randomEnemy

func _ready() -> void:
	size = $colshape.shape.extents

func _on_Timer_timeout() -> void:
	
	randomEnemy = randi() % len(enemies)
	var positionX = (randi() % int(size.x * 2) + 1)
	
	var spawnPosition = Vector2(positionX, 10)
	
	var selected_enemy = enemies[randomEnemy].instance()
	get_tree().current_scene.add_child(selected_enemy)
	selected_enemy.position = spawnPosition
