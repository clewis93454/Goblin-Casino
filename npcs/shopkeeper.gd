extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var player_in_range: bool = false


func _ready() -> void:
	animated_sprite.play("idle")


func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		GameEvents.shop_opened.emit()
		get_viewport().set_input_as_handled()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.show_interact_prompt()
		player_in_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.hide_interact_prompt()
		player_in_range = false
