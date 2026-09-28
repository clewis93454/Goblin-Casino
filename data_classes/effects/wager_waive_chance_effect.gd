class_name WagerWaiveChanceEffect
extends ItemEffect

@export_range(0.0, 1.0, 0.01) var chance: float = 0.1


func should_waive_wager(_context: CasinoGameContext) -> bool:
	return randf() < chance
