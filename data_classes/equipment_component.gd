class_name EquipmentComponent
extends Node

signal equipment_changed(slot: Item.Slot, item: Item)

var equipped: Dictionary[Item.Slot, Item] = {}


func equip(item: Item) -> Item:
	if not can_equip(item):
		return null

	var previous_item: Item = equipped.get(item.slot)

	if previous_item == item:
		return null

	equipped[item.slot] = item

	equipment_changed.emit(item.slot, item)

	return previous_item


func unequip(slot: Item.Slot) -> Item:
	var previous_item: Item = equipped.get(slot)

	if previous_item == null:
		return null

	equipped.erase(slot)

	equipment_changed.emit(slot, null)
	return previous_item


func get_equipped(slot: Item.Slot) -> Item:
	return equipped.get(slot)


func can_equip(item: Item) -> bool:
	return item.slot in [Item.Slot.HELM, Item.Slot.CHEST, Item.Slot.LEGS]
