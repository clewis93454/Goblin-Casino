extends Node2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var gold_label: Label = $CanvasLayer/ShopUI/GoldLabel
@onready var shopkeer_gold_label: Label = $CanvasLayer/ShopUI/ShopkeeperGoldLabel
@onready
var player_inventory_list: ItemList = $CanvasLayer/ShopUI/PlayerInventoryContainer/PlayerInventory
@onready
var shopkeeper_inventory_list: ItemList = $CanvasLayer/ShopUI/ShopInventoryContainer/ShopInventory
@onready var sell_button: Button = $CanvasLayer/ShopUI/PlayerInventoryContainer/SellButton
@onready var buy_button: Button = $CanvasLayer/ShopUI/ShopInventoryContainer/BuyButton

enum Side { NONE, PLAYER, SHOP }

var selected_side = Side.NONE
var selected_item: Item = null:
	set(value):
		selected_item = value
		_refresh_buttons()


func _ready() -> void:
	canvas_layer.visible = false
	PlayerInventory.gold_changed.connect(_on_gold_changed)
	PlayerInventory.item_added.connect(_refresh_items)
	PlayerInventory.item_removed.connect(_refresh_items)

	ShopkeeperInventory.gold_changed.connect(_on_shopkeeper_gold_change)
	ShopkeeperInventory.item_added.connect(_refresh_items)
	ShopkeeperInventory.item_removed.connect(_refresh_items)

	GameEvents.shop_opened.connect(_on_shop_opened)
	GameEvents.shop_closed.connect(_on_shop_closed)

	player_inventory_list.item_selected.connect(_on_player_item_selected)
	shopkeeper_inventory_list.item_selected.connect(_on_shop_item_selected)

	gold_label.text = "GOLD: %dg" % PlayerInventory.gold
	shopkeer_gold_label.text = "Shopkeer GOLD: %dg" % ShopkeeperInventory.gold

	load_player_items()
	load_shopkeeper_items()


func _on_shop_opened() -> void:
	canvas_layer.visible = true


func _on_shop_closed() -> void:
	canvas_layer.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		GameEvents.shop_closed.emit()


func _on_gold_changed(amount: int):
	gold_label.text = "GOLD: %dg" % amount


func _on_shopkeeper_gold_change(amount: int):
	shopkeer_gold_label.text = "Shopkeer GOLD: %dg" % amount


func load_player_items():
	for item in PlayerInventory.items:
		var idx = player_inventory_list.add_item("%s - %dg" % [item.display_name, item.value])
		player_inventory_list.set_item_metadata(idx, item)
		player_inventory_list.set_item_tooltip(idx, item.description)


func load_shopkeeper_items():
	for item in ShopkeeperInventory.items:
		var idx = shopkeeper_inventory_list.add_item("%s - %dg" % [item.display_name, item.value])
		shopkeeper_inventory_list.set_item_metadata(idx, item)
		shopkeeper_inventory_list.set_item_tooltip(idx, item.description)


func _refresh_buttons():
	if selected_side == Side.PLAYER:
		sell_button.disabled = false
		buy_button.disabled = true

	if selected_side == Side.SHOP:
		buy_button.disabled = false
		sell_button.disabled = true

	if selected_side == Side.NONE:
		buy_button.disabled = true
		sell_button.disabled = true


func _on_player_item_selected(index: int):
	var item: Item = player_inventory_list.get_item_metadata(index)

	if item == selected_item:
		selected_side = Side.NONE
		selected_item = null
		player_inventory_list.deselect(index)
		return

	shopkeeper_inventory_list.deselect_all()
	selected_side = Side.PLAYER
	selected_item = item


func _on_shop_item_selected(index: int):
	var item: Item = shopkeeper_inventory_list.get_item_metadata(index)

	if item == selected_item:
		selected_side = Side.NONE
		selected_item = null
		shopkeeper_inventory_list.deselect(index)
		return

	player_inventory_list.deselect_all()
	selected_side = Side.SHOP
	selected_item = item


func _refresh_items(_item: Item):
	player_inventory_list.clear()
	shopkeeper_inventory_list.clear()
	load_player_items()
	load_shopkeeper_items()


func _transfer(item: Item, seller: InventoryComponent, buyer: InventoryComponent) -> void:
	if buyer.gold >= item.value:
		seller.remove_item(item)
		buyer.add_item(item)
		buyer.remove_gold(item.value)
		seller.add_gold(item.value)

		selected_side = Side.NONE
		selected_item = null


func _on_sell_button_pressed() -> void:
	if selected_item:
		_transfer(selected_item, PlayerInventory, ShopkeeperInventory)

func _on_buy_button_pressed() -> void:
	if selected_item:
		_transfer(selected_item, ShopkeeperInventory, PlayerInventory)