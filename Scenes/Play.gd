extends TextureButton


func _ready() -> void:
	anim_spawn()
	pressed.connect(_on_pressed)


func anim_spawn() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	scale = Vector2.ONE * 1.5
	tween.tween_property(self, "scale", Vector2.ONE , 0.5)

func anim_pressed() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	scale = Vector2.ONE * 1.5
	tween.tween_property(self, "scale", Vector2.ZERO , 0.5)
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/Test.tscn")


func _on_pressed() -> void:
	anim_pressed()
