extends KinematicBody2D
class_name Enemy

export var speed = 100
export var max_health = 1
export (Color) var healty_color = Color.green
export (Color) var warning_color = Color.yellow
export (Color) var danger_color = Color.red

var velocity = Vector2.ZERO
onready var health_bar = $Health_bar
onready var sprite = $EnemySprite

onready var health = max_health 
var explosionAnim = preload("res://Scenes/ExplosionAnimation.tscn")
onready var explosion = explosionAnim.instance()

var is_dead = false
export (int) var enemyScore = 1;

func _ready() -> void:
	health_bar.rect_pivot_offset += Vector2(0, sprite.position.y - 35)
	health_bar.max_value = max_health
	health_bar.visible = false

func _physics_process(delta: float) -> void:
	explosion.position = self.position
	if health <= 0:
		is_dead = true
	move_local_y(delta * speed)
	if self.position.y > get_viewport().get_visible_rect().size.y:
		queue_free()

func _on_HitBox_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_bit(1):
		queue_free()
		get_tree().current_scene.add_child(explosion)
		explosion.play("Explosion")
	else:
		health_bar.visible = true
		health -= area.get_parent().damage
		_assign_health_bar_color()
	
func _assign_health_bar_color():
	health_bar.value = health
	if health < health_bar.max_value * 0.2:
		health_bar.tint_progress = danger_color
	elif health < health_bar.max_value * 0.5:
		health_bar.tint_progress = warning_color
	else: 
		health_bar.tint_progress = healty_color
	

