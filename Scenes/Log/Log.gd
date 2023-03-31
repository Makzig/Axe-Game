extends Node2D
class_name Log

@onready var _anim_player:AnimationPlayer = $AnimationPlayer
@onready var _hurt_box:Area2D = $Sprite/HurtBox

signal killed


func _ready() -> void:
	_hurt_box.area_entered.connect(_on_entered)
	set_process(false)
	set_process_input(false)

func _process(delta):
	position.y += delta * 200




func _input(event) -> void:
	if event is InputEventScreenDrag:
		position.y += event.relative.y

func _on_entered(area) -> void:
	if area.is_in_group("AxeAttack"):
		await get_tree().create_timer(0.3).timeout
		if area.owner.good_attack and area.owner._state != area.owner.AxeState.STUCK:
			await get_tree().create_timer(0.1).timeout
			if !_anim_player.is_playing():
				emit_signal("killed")
				_anim_player.play("Fall")
				set_process(true)
				await _anim_player.animation_finished
				queue_free()
		elif area.owner._state == area.owner.AxeState.STUCK and area.owner.good_attack:
			set_process_input(true)
