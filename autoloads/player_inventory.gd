extends InventoryComponent

var equipment: EquipmentComponent = EquipmentComponent.new()


func _ready() -> void:
	add_item(preload("res://resources/items/cheapskate_helm.tres"))
	add_child(equipment)
	gold = 100


func equip_from_inventory(item: Item) -> void:
	if not equipment.can_equip(item):
		return

	if not items.has(item):
		return

	remove_item(item)
	var item_being_replaced: Item = equipment.equip(item)

	if item_being_replaced != null:
		add_item(item_being_replaced)


func unequip_to_inventory(slot: Item.Slot) -> void:
	var item: Item = equipment.unequip(slot)

	if item:
		add_item(item)
