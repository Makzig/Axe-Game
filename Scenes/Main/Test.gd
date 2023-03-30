extends Node2D



var _log:PackedScene = load("res://Scenes/Log/log.tscn")
var log_count:int = 5
var _is_stuck:bool


func _ready() -> void:
	$Log.killed.connect(_on_killed)
	EventBus.winned.connect(_on_winned)
	$Axe.stucked.connect(_on_stucked)
	$Axe.stuck_finished.connect(_on_stuck_finished)


func _on_killed() -> void:
	if _is_stuck:return
	if log_count > 0:
		@warning_ignore("shadowed_global_identifier")
		var log:Log = _log.instantiate()
		log.position = $SpawnPos.position
		await get_tree().create_timer(2).timeout
		anim_move(log)
		log.connect("killed", _on_killed)
		self.add_child(log)
		log_count -= 1
	else:
		EventBus.winned.emit()



func anim_move(target:Log) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "position", $NeesPos.position, 1 )


func _on_winned() -> void:
	$Log.visible = false
	$Axe.visible = false
	$Scroller.visible = false

func _on_stucked() -> void:
	_is_stuck  = true



func _on_stuck_finished() -> void:
	_is_stuck = false
	_on_killed()
