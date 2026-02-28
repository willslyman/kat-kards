extends CollisionShape2D
class_name CardBase

func select() -> void:
	$AnimationPlayer.play("select")

func deselect() -> void:
	$AnimationPlayer.play("deselect")
