class_name FlatCostReductionEffect
extends ItemEffect

@export_range(0, 100) var reduction_amount: int = 0


func modify_cost(cost: int, _context: CasinoGameContext) -> int:
	return maxi(cost - reduction_amount, 0)
