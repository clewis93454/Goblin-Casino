extends Node

const MAX_VALUES: int = 7
const TICKER_ITERATIONS: int = 10
const DEFAULT_COST: int = 5
const DEFAULT_PAYOUT: int = 10

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


func create_context() -> CasinoGameContext:
	return CasinoGameContext.new(CasinoGameContext.Game.SLOTS, DEFAULT_COST, DEFAULT_PAYOUT)


func _on_equipment_changed(_slot: Item.Slot, _item: Item) -> void:
	update_cost_label()


func update_cost_label() -> void:
	cost_label.text = "Cost: %dg" % calculate_pull_cost(create_context())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_pull:
		var context: CasinoGameContext = create_context()
		var cost: int = calculate_pull_cost(context)

		if PlayerInventory.gold >= cost:
			handle_lever_pull(cost, context)

	if event.is_action_pressed("escape") && can_pull:
		GameEvents.slot_machine_closed.emit()


func handle_lever_pull(cost: int, context: CasinoGameContext) -> void:
	can_pull = false
	pull_label.visible = false

	if not PlayerInventory.equipment.should_waive_wager(context):
		PlayerInventory.remove_gold(cost)

	lever.play("pull")
	payout_label.text = "Payout: 000"
	seed_tickers()


func _on_lever_pull_finish() -> void:
	await animate_tickers()
	calculate_score(left_ticker_order.back(), middle_ticker_order.back(), right_ticker_order.back())

func animate_tickers() -> void:
	await play_ticker_sequence(left_ticker, left_ticker_order)
	await play_ticker_sequence(middle_ticker, middle_ticker_order)
	await play_ticker_sequence(right_ticker, right_ticker_order)

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
		var random_int: int = randi_range(0, MAX_VALUES - 1)
		ticker_array.push_back(random_int)

	return ticker_array


func calculate_score(
	left_ticker_value: int, middle_ticker_value: int, right_ticker_value: int
) -> void:
	var context: CasinoGameContext = create_context()
	var payout: int

	# jackpot
	if left_ticker_value == middle_ticker_value && left_ticker_value == right_ticker_value:
		payout = PlayerInventory.equipment.get_modified_payout(context) * 10
		payout_label.text = "Payout: %s" % payout
		PlayerInventory.add_gold(payout)
		return

	# wins
	if left_ticker_value == middle_ticker_value:
		payout = PlayerInventory.equipment.get_modified_payout(context)
		payout_label.text = "Payout: %s" % payout
		PlayerInventory.add_gold(payout)
		return

	if left_ticker_value == right_ticker_value:
		payout = PlayerInventory.equipment.get_modified_payout(context)
		payout_label.text = "Payout: %s" % payout
		PlayerInventory.add_gold(payout)
		return

	if right_ticker_value == middle_ticker_value:
		payout = PlayerInventory.equipment.get_modified_payout(context)
		payout_label.text = "Payout: %s" % payout
		PlayerInventory.add_gold(payout)
		return

	# loss
	payout_label.text = "Payout: 000"


func calculate_pull_cost(context: CasinoGameContext) -> int:
	return PlayerInventory.equipment.get_modified_cost(context)
