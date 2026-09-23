extends CanvasLayer

@onready var gold_label: Label = $GoldLabel
@onready var inventory_panel: Panel = $InventoryPanel
@onready var toggle_inventory_button: Button = $ToggleInventoryButton
@onready var item_list: ItemList = $InventoryPanel/ItemList

var in_shop_menu: bool = false


func _ready() -> void:
	PlayerInventory.gold_changed.connect(_on_gold_changed)
	PlayerInventory.item_added.connect(_refresh_items.call_deferred)
	PlayerInventory.item_removed.connect(_refresh_items.call_deferred)
	GameEvents.shop_opened.connect(_on_shop_opened)
	GameEvents.shop_closed.connect(_on_shop_closed)

	gold_label.text = "GOLD: %dg" % PlayerInventory.gold
	inventory_panel.visible = false
	load_items()
	item_list.item_selected.connect(_on_item_selected)


func _on_gold_changed(amount: int):
	gold_label.text = "GOLD: %dg" % amount


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory") && not in_shop_menu:
		toggle_inventory()


func _on_toggle_inventory_button_pressed() -> void:
	toggle_inventory()


func toggle_inventory():
	inventory_panel.visible = not inventory_panel.visible


func _on_item_selected(index: int) -> void:
	var item: Item = item_list.get_item_metadata(index)
	PlayerInventory.equip_from_inventory(item)


func load_items():
	for item in PlayerInventory.items:
		var idx = item_list.add_item(item.display_name)
		item_list.set_item_metadata(idx, item)


func _refresh_items(_item: Item) -> void:
	item_list.clear()
	load_items()


func set_hud_visibility(hud_visible: bool) -> void:
	gold_label.visible = hud_visible
	toggle_inventory_button.visible = hud_visible


func _on_shop_opened() -> void:
	in_shop_menu = true
	set_hud_visibility(false)


func _on_shop_closed() -> void:
	in_shop_menu = false
	set_hud_visibility(true)
