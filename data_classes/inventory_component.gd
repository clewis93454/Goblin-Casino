class_name InventoryComponent
extends Node

signal gold_changed(amount: int)
signal item_added(item: Item)
signal item_removed(item: Item)

var gold: int = 0:
	set(value):
		gold = value
		gold_changed.emit(gold)


func add_gold(amount: int) -> void:
	gold += amount


func remove_gold(amount: int) -> void:
	gold -= amount


var items: Array[Item] = []:
	set(value):
		items = value


func add_item(item: Item) -> void:
	items.append(item)
	item_added.emit(item)


func remove_item(item: Item) -> void:
	var idx: int = items.find(item)

	if idx == -1:
		return

	items.remove_at(idx)
	item_removed.emit(item)
