class_name ItemEffect
extends Resource

@export var supported_games: Array[CasinoGameContext.Game] = []
@export var priority: int = 0


func modify_cost(cost: int, _context: CasinoGameContext) -> int:
	return cost


func should_waive_wager(_context: CasinoGameContext) -> bool:
	return false


func modify_payout(payout: int, _context: CasinoGameContext) -> int:
	return payout


func applies(context: CasinoGameContext) -> bool:
	if supported_games.is_empty():
		return true

	return context.game in supported_games
