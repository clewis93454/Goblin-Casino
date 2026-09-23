class_name Item
extends Resource

enum Slot { CONSUMABLE, JUNK, HELM, CHEST, LEGS }

@export var id: StringName
@export var display_name: String
@export var icon: Texture2D
@export var description: String
@export var slot: Slot
@export var value: int
# TODO: add an effect here to be used later during games
