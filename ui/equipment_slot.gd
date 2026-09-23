extends Button

@export var slot: Item.Slot
@export var empty_icon: Texture2D


func _ready() -> void:
	PlayerInventory.equipment.equipment_changed.connect(_on_equipment_changed)
	_display(PlayerInventory.equipment.get_equipped(slot))


func _display(item: Item) -> void:
	if item == null:
		icon = empty_icon
		text = "NONE"
	else:
		icon = item.icon
		text = item.display_name


func _on_equipment_changed(changed_slot: Item.Slot, item: Item):
	if changed_slot != slot:
		return

	_display(item)


func _on_pressed() -> void:
	PlayerInventory.unequip_to_inventory(slot)
