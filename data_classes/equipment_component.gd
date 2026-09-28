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


func get_active_effects(context: CasinoGameContext) -> Array[ItemEffect]:
	var active: Array[ItemEffect] = []

	for item: Item in equipped.values():
		for effect: ItemEffect in item.effects:
			if effect.applies(context):
				active.append(effect)

	active.sort_custom(func(a: ItemEffect, b: ItemEffect) -> bool: return a.priority < b.priority)

	return active


func get_modified_cost(context: CasinoGameContext) -> int:
	var cost: int = context.base_cost
	var active_effects: Array[ItemEffect] = get_active_effects(context)

	for effect: ItemEffect in active_effects:
		cost = effect.modify_cost(cost, context)

	return cost


func should_waive_wager(context: CasinoGameContext) -> bool:
	var active_effects: Array[ItemEffect] = get_active_effects(context)

	for effect: ItemEffect in active_effects:
		if effect.should_waive_wager(context):
			return true

	return false


func get_modified_payout(context: CasinoGameContext) -> int:
	var payout: int = context.base_payout
	var active_effects: Array[ItemEffect] = get_active_effects(context)

	for effect: ItemEffect in active_effects:
		payout = effect.modify_payout(payout, context)

	print("effects: %d, base: %d, final: %d" % [active_effects.size(), context.base_payout, payout])
	return payout
