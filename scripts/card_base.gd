extends CollisionShape2D
class_name CardBase

func select() -> void:
	$AnimationPlayer.play("select")

func deselect() -> void:
	$AnimationPlayer.play("deselect")

func set_texture(texture : Texture2D) -> void:
	$Sprite2D.texture = texture
