extends Area2D
class_name Card

var selected : bool = false
@onready var anim: AnimationPlayer = $AnimationPlayer

func select() -> void:
	if !selected:
		anim.play("select")
	else:
		anim.play("deselect")
	selected = !selected
