extends Node2D

var velocity:= Vector2()
export var speed := 200.0
var explosionAnim = preload("res://Scenes/ExplosionAnimation.tscn")
onready var explosion = explosionAnim.instance()
var damage:int = 1

func _ready() -> void:
	get_node("AnimationPlayer").play("FireAnim")
	velocity.y = -900

func _process(_delta: float) -> void:
	if self.position.y <= 0:
		queue_free()
	
func _physics_process(delta: float) -> void:
	move_local_y(delta * -speed)
	explosion.position = self.position

func _on_area_area_entered(_area: Area2D) -> void:
	queue_free()
	get_tree().current_scene.add_child(explosion)
	explosion.play("Explosion")

func set_damage(amount):
	self.damage = amount
