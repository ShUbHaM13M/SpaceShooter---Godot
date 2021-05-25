extends Node2D

var score:int
onready var ui = $UI

func _ready() -> void:
	score = 0
	
func _process(_delta: float) -> void:
	var children = get_children()
	for child in children:
		if child is Enemy:
			if child.is_dead:
				updateUIscore(child.enemyScore)
				child.queue_free()

func updateUIscore(amount):
	score += amount
	ui.set_score(score)
