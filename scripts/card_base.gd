extends CollisionShape2D
class_name CardBase

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func hover() -> void:
	if animation_player.assigned_animation != "select":
		animation_player.play("select")

func unhover() -> void:
	if animation_player.assigned_animation not in ["deselect", ""]:
		animation_player.play("deselect")

func block_select() -> void:
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("block_select")
	
func use() -> void:
	$AnimationPlayer.play("use")
	
func un_use() -> void:
	$AnimationPlayer.play_backwards("use")

func set_texture(texture : Texture2D) -> void:
	$Sprite2D.texture = texture
