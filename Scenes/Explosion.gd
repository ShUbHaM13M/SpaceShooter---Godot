extends AnimatedSprite

func _on_ExplosionAnimation_animation_finished() -> void:
	queue_free()
