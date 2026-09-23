extends InventoryComponent


func _ready() -> void:
	add_item(preload("res://resources/items/shifty_hood.tres"))
	gold = 1000
