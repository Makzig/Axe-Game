extends Node2D
class_name Scroller


@export_range(0.1, 5, 0.1) var scroll_speed:float
@export_node_path("Axe") var axe_path


@onready var _scroll_path_follow:PathFollow2D = $Path2D/ScrollPath
@onready var _stoppers:Node2D = $Path2D/Stoppers


var _axe:Axe

var is_good_attack:bool = false




func _ready() -> void:
	if axe_path:
		_axe = get_node(axe_path)
		_axe.stucked.connect(_on_stucked)
		_axe.stuck_finished.connect(_on_stuck_finished)
	connect_stoppers()

func _process(delta) -> void:
	_scroll_path_follow.progress_ratio += scroll_speed * delta


func _input(event):
	if event is InputEventScreenTouch or (event is InputEventMouseButton and event.is_pressed()):
		set_process(false)
		await get_tree().create_timer(0.75).timeout
		set_process(true)
	

func connect_stoppers() -> void:
	if _stoppers.get_child_count() > 0:
		for stoper in _stoppers.get_children():
			stoper.attack_false.connect(_on_attack_false)
			stoper.attack_good.connect(_on_attack_good)


func _on_attack_false() -> void:
	is_good_attack = false

func _on_attack_good() -> void:
	is_good_attack = true

func _on_stucked() -> void:
	set_process_input(false)
	set_physics_process(false)

func _on_stuck_finished() -> void:
	set_process_input(true)
	set_physics_process(true)
