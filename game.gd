extends Node

@onready var sandbox_view: Node2D = $SandboxView
@onready var slot_machine_view: Node2D = $SlotMachineView
@onready var slot_machine_camera: Camera2D = $SlotMachineView/Camera2D
@onready var player_camera: Camera2D = $SandboxView/Player/Camera2D
@onready var shop_view: Node2D = $ShopView
@onready var shop_view_camera: Camera2D = $ShopView/Camera2D


func _ready() -> void:
	slot_machine_view.visible = false
	GameEvents.slot_machine_opened.connect(_on_slot_machine_opened)
	GameEvents.slot_machine_closed.connect(_on_slot_machine_closed)
	GameEvents.shop_opened.connect(_on_shop_opened)
	GameEvents.shop_closed.connect(_on_shop_closed)


func _on_slot_machine_opened() -> void:
	slot_machine_view.process_mode = Node.PROCESS_MODE_INHERIT
	sandbox_view.visible = false
	sandbox_view.process_mode = Node.PROCESS_MODE_DISABLED
	slot_machine_view.visible = true
	slot_machine_camera.make_current()


func _on_slot_machine_closed() -> void:
	slot_machine_view.visible = false
	slot_machine_view.process_mode = Node.PROCESS_MODE_DISABLED
	sandbox_view.process_mode = Node.PROCESS_MODE_INHERIT
	sandbox_view.visible = true
	player_camera.make_current()


func _on_shop_opened() -> void:
	shop_view.process_mode = Node.PROCESS_MODE_INHERIT
	sandbox_view.visible = false
	sandbox_view.process_mode = Node.PROCESS_MODE_DISABLED
	shop_view.visible = true
	shop_view_camera.make_current()


func _on_shop_closed() -> void:
	shop_view.visible = false
	shop_view.process_mode = Node.PROCESS_MODE_DISABLED
	sandbox_view.process_mode = Node.PROCESS_MODE_INHERIT
	sandbox_view.visible = true
	player_camera.make_current()