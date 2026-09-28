class_name PayoutIncreaseEffect
extends ItemEffect

@export_range(0.0, 1.0, 0.01) var percent_increase: float = 0.5


func modify_payout(payout: int, _context: CasinoGameContext) -> int:
	return int(ceil(payout + (payout * percent_increase)))
