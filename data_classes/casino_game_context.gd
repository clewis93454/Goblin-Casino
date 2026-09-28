class_name CasinoGameContext
extends RefCounted

enum Game { SLOTS, ROULETTE }

var game: Game
var base_cost: int
var base_payout: int


func _init(p_game: Game, p_base_cost: int, p_base_payout: int) -> void:
	game = p_game
	base_cost = p_base_cost
	base_payout = p_base_payout
