extends CollisionShape2D
class_name CardBase

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func select() -> void:
	$AnimationPlayer.play("select")

func deselect() -> void:
	$AnimationPlayer.play("deselect")

func block_select() -> void:
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("block_select")
	
func use() -> void:
	$AnimationPlayer.play("use")
	
func un_use() -> void:
	$AnimationPlayer.play_backwards("use")

func set_texture(texture : Texture2D) -> void:
	$Sprite2D.texture = texture
