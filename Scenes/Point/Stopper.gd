extends Area2D


var _point:Area2D


signal attack_good
signal attack_false


func _ready() -> void:
	area_entered.connect(_on_entered)
	area_exited.connect(_on_exited)


func _on_entered(area) -> void:
	if area.is_in_group("Point"):
		_point = area
		attack_good.emit()

func _on_exited(area) -> void:
	if area.is_in_group("Point"):
		_point = null
		attack_false.emit()
