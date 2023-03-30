extends Control


@onready var container = $VBoxContainer

func _ready() -> void:
	get_tree().paused = false
	visible = false
	EventBus.winned.connect(_on_winned)
	for obj in container.get_children():
		obj.scale = Vector2.ZERO


func _on_winned() -> void:
	visible = true
	anim_show()
	get_tree().paused = true

#func _input(event):
	#if event is InputEventMouseButton and event.is_pressed():
		#EventBus.winned.emit()


func anim_show() -> void:
	for obj in container.get_children():
		var tween := create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		obj.scale = Vector2.ZERO
		#obj.rotation_degrees = -45.0
		tween.tween_property(obj, "scale", Vector2.ONE, 1)
		#tween.parallel().tween_property(obj, "rotation_degrees", 0, 1)
