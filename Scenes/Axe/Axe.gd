extends Node2D
class_name Axe


enum AxeState{IDLE, ATTACK, STUCK, LOSE}

@export_node_path("Node2D") var scroller 
@export var health:int = 3

@onready var _attack_area:Area2D = $Sprite2D/AttackArea
@onready var _scroll:Scroller
@onready var _anim_player:AnimationPlayer = $AnimationPlayer

var _state:AxeState
var this_stuck:float = 0.0
var stuck_count:float = 350.0

var good_attack:bool = false

signal stucked
signal stuck_finished


func  _ready() -> void:
	if scroller:
		_scroll = get_node(scroller)
	_attack_area.area_entered.connect(_on_attack_entered)
	EventBus.killed.connect(_on_killed)


func _input(event):
	if event is InputEventScreenTouch or (event is InputEventMouseButton and !event.is_pressed()) and _state != AxeState.STUCK:
		good_attack = _scroll.good_attack
		if _state == AxeState.IDLE:
			attack()
			
	if event is InputEventScreenDrag  and _state == AxeState.STUCK:
		self.position.y += event.relative.y
		this_stuck += 0.5
		if this_stuck >= stuck_count:
			stuck_finished.emit()
			_state = AxeState.IDLE



func attack() -> void:
	_state = AxeState.ATTACK
	_anim_player.play("Attack")



func check_attack() -> void:
	if _scroll.good_attack:
		var chance_stuck = 0.25
		if randf_range(0, 1) <= chance_stuck:
			_state = AxeState.STUCK
			_anim_player.play("Stuck")
			stucked.emit()
		else:
			if _anim_player.is_playing():
				await  _anim_player.animation_finished
			_anim_player.play_backwards("Attack")
			await _anim_player.animation_finished
			_state = AxeState.IDLE
			_anim_player.play("Idle")
	else:
		health -= 1
		_anim_player.play("False")
		await  _anim_player.animation_finished
		_anim_player.play("Idle")
		_state = AxeState.IDLE
		if health <= 0:
			EventBus.killed.emit()


func _on_attack_entered(area) -> void:
	if area.is_in_group("Log"):
		check_attack()
		#pass

func _on_killed() -> void:
	_state = AxeState.LOSE
