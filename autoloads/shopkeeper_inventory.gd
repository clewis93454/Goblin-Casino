extends InventoryComponent


func _ready() -> void:
	add_item(preload("res://resources/items/shifty_hood.tres"))
	add_item(preload("res://resources/items/jackpot_jorts.tres"))
	gold = 1000
