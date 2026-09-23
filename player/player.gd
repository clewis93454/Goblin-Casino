extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_label: Label = $InteractLabel
@onready var camera: Camera2D = $Camera2D

const SPEED: float = 50.0


func _ready() -> void:
	camera.make_current()


func _physics_process(_delta: float) -> void:
	handle_input()


func handle_input() -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction == Vector2.RIGHT:
		animated_sprite.flip_h = false
	if direction == Vector2.LEFT:
		animated_sprite.flip_h = true

	if direction != Vector2.ZERO:
		animated_sprite.play("move_right")
	else:
		animated_sprite.play("idle")

	velocity = direction * SPEED
	move_and_slide()


func show_interact_prompt() -> void:
	interact_label.visible = true


func hide_interact_prompt() -> void:
	interact_label.visible = false
