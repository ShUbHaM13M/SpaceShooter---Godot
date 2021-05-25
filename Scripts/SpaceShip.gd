extends KinematicBody2D

signal health_changed()

var touchInputs

export var speed:= 200.0
var velocity:= Vector2()
export var acceleration:= 0.8
export var friction:= 0.3
export var max_health = 100
var dir_x = 0
var dir_y = 0

export var damage:int = 1 
var viewport := Vector2()
onready var size = $PLayerSprite.get_rect().size
onready var health = max_health

onready var joystick = get_parent().get_node("JoyStick/JoyStickButton")

var score = 0

func _ready() -> void:
	var after_burn_anim = get_node("AfterBurnAnimPLayer").get_animation("AfterBurnAnim")
	after_burn_anim.set_loop(true)
	get_node("AfterBurnAnimPLayer").play("AfterBurnAnim")
	viewport = get_viewport().get_visible_rect().size
	touchInputs = InputEventScreenTouch.new()

func get_input():
	
	dir_x = 0
	dir_y = 0

	if Input.is_action_pressed("ui_down"):
		dir_y += 1
	elif Input.is_action_pressed("ui_up"):
		dir_y -= 1
	
	if Input.is_action_pressed("ui_right"):
		dir_x += 1
	elif Input.is_action_pressed("ui_left"):
		dir_x -= 1

func _friction():
	if dir_y != 0:
		velocity.y = lerp(velocity.y, dir_y * speed, acceleration)
	else:
		velocity.y = lerp(velocity.y, 0, friction)
	if dir_x != 0:
		velocity.x = lerp(velocity.x, dir_x * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func _physics_process(_delta: float) -> void:
	get_input()
	_friction()
	velocity = move_and_slide(velocity)
	self.position = Vector2(
		clamp(self.position.x, 0 + size.x, viewport.x - size.x),
		clamp(self.position.y, viewport.y * 0.25 + size.y, viewport.y - size.y))

func _process(_delta: float) -> void:
	velocity = joystick.get_value() * speed
	if health <= 0:
		queue_free()
		get_tree().quit()


func fire() -> void:
	var projectile = load("res://Scenes//gunFire.tscn")
	var bullet = projectile.instance()
	owner.add_child(bullet)
	bullet.set_damage(damage)
	bullet.position = $PLayerSprite.global_position + Vector2(-2, -100)


func _on_HurtBox_area_entered(_area: Area2D) -> void:
	health -= 10
	emit_signal("health_changed", health)


func _on_shoot_delay_timeout() -> void:
	fire()

