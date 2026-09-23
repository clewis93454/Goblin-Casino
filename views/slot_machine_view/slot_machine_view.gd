extends Node

const MAX_VALUES: int = 7
const TICKER_ITERATIONS: int = 10
const DEFAULT_COST: int = 5

@onready var lever: AnimatedSprite2D = $Body/Lever
@onready var left_ticker: AnimatedSprite2D = $Body/LeftTicker
@onready var middle_ticker: AnimatedSprite2D = $Body/MiddleTicker
@onready var right_ticker: AnimatedSprite2D = $Body/RightTicker
@onready var pull_label: Label = $PullLabel
@onready var payout_label: Label = $PayoutLabel
@onready var cost_label: Label = $CostLabel

var can_pull: bool = true
var left_ticker_order: Array[int] = []
var middle_ticker_order: Array[int] = []
var right_ticker_order: Array[int] = []


func _ready() -> void:
	lever.animation_finished.connect(_on_lever_pull_finish)
	PlayerInventory.equipment.equipment_changed.connect(_on_equipment_changed)
	update_cost_label()
	can_pull = true


func _on_equipment_changed(_slot: Item.Slot, _item: Item):
	update_cost_label()


func update_cost_label() -> void:
	cost_label.text = "Cost: %dg" % calculate_pull_cost()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_pull && PlayerInventory.gold >= 10:
		handle_lever_pull()

	if event.is_action_pressed("escape") && can_pull:
		GameEvents.slot_machine_closed.emit()


func handle_lever_pull() -> void:
	can_pull = false
	pull_label.visible = false
	PlayerInventory.remove_gold(calculate_pull_cost())
	lever.play("pull")
	payout_label.text = "Payout: 000"
	seed_tickers()


func _on_lever_pull_finish() -> void:
	animate_tickers()


func animate_tickers() -> void:
	await play_ticker_sequence(left_ticker, left_ticker_order)
	await play_ticker_sequence(middle_ticker, middle_ticker_order)
	await play_ticker_sequence(right_ticker, right_ticker_order)
	calculate_score(left_ticker_order.back(), middle_ticker_order.back(), right_ticker_order.back())
	can_pull = true
	pull_label.visible = true


func play_ticker_sequence(
	ticker: AnimatedSprite2D, order: Array[int], interval: float = 0.075
) -> void:
	for value in order:
		ticker.frame = value
		await get_tree().create_timer(interval).timeout


func seed_tickers() -> void:
	left_ticker_order.clear()
	middle_ticker_order.clear()
	right_ticker_order.clear()

	left_ticker_order = generate_random_ticker_order()
	middle_ticker_order = generate_random_ticker_order()
	right_ticker_order = generate_random_ticker_order()


func generate_random_ticker_order() -> Array[int]:
	var ticker_array: Array[int] = []

	for i in TICKER_ITERATIONS:
		var random_int = randi_range(0, MAX_VALUES - 1)
		ticker_array.push_back(random_int)

	return ticker_array


func calculate_score(left_ticker_value: int, middle_ticker_value: int, right_ticker_value: int):
	if left_ticker_value == middle_ticker_value && left_ticker_value == right_ticker_value:
		payout_label.text = "Payout: 100"
		PlayerInventory.add_gold(100)
		return

	if left_ticker_value == middle_ticker_value:
		payout_label.text = "Payout: 010"
		PlayerInventory.add_gold(10)
		return

	if left_ticker_value == right_ticker_value:
		payout_label.text = "Payout: 010"
		PlayerInventory.add_gold(10)
		return

	if right_ticker_value == middle_ticker_value:
		payout_label.text = "Payout: 010"
		PlayerInventory.add_gold(10)
		return

	payout_label.text = "Payout: 000"


func calculate_pull_cost() -> int:
	var helm: Item = PlayerInventory.equipment.get_equipped(Item.Slot.HELM)
	if helm and helm.id == "1":
		return DEFAULT_COST - 1

	return DEFAULT_COST
