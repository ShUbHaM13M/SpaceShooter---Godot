extends MarginContainer

# warning-ignore:unused_signal
signal pulse

onready var health_over = $HBoxContainer/HealthUI/HealthBar
onready var health_under = $HBoxContainer/HealthUI/HealthUnder
onready var tween = $HBoxContainer/HealthUI/animate
onready var pulse = $HBoxContainer/HealthUI/pulse
onready var heart = $HBoxContainer/HealthUI/Heart
onready var score = $HBoxContainer/Score

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (Color) var pulse_color = Color.red

export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.2

export (bool) var can_pulse = true

func _ready() -> void:
	score.set("Align", "center")
	score.set("Valign", "center")
	score.clear()
	score.text = "Score: 0"

func _on_SpaceShip_health_changed(health) -> void:
	update_health(health)

func update_health(health):
	health_over.value = health
	tween.interpolate_property(health_under, "value", health_under.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	tween.start()
	
	_assign_colors(health)

func _assign_colors(health):
	if health == 0:
		pulse.set_active(false)
	elif health < health_over.max_value * danger_zone:
		pulse.interpolate_property(health_over, "tint_progress", pulse_color, danger_color, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		pulse.interpolate_callback(self, 0.0, "emit_signal", "pulse")
		pulse.start()

	else:
		pulse.set_active(false)
		if health < health_over.max_value * caution_zone:
			health_over.tint_progress = caution_color
		else:
			health_over.tint_progress = healthy_color

func on_max_health_updated(max_health):
	health_over.max_value = max_health
	health_under.max_value = max_health

func set_score(num:int) -> void:
	score.clear()
	score.text += "Score: " + str(num)
