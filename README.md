# Conjuring Casino

A fantasy-themed casino game built around a collection of gambling minigames. Wander the casino floor, try your luck at the machines, and trade gear with the shopkeeper.

This is a personal project for learning [Godot](https://godotengine.org/).

## Features

- **Slot machine** — pull the lever, match the tickers, win gold
- **Shop** — buy and sell items with the shopkeeper; both sides have their own gold and inventory
- **Inventory & equipment** — equip helm, chest, and leg gear; equipped items can affect minigames (e.g. the Cheapskate Helm lowers the slot machine's pull cost)

## Controls

| Action | Key |
|---|---|
| Move | WASD / Arrow keys |
| Interact | E |
| Toggle inventory | Tab |
| Close menu | Esc |

## Running

Requires **Godot 4.7**.

1. Open `project.godot` in the Godot editor.
2. Press **F5** to run the main scene.

Or from the command line, with Godot on your PATH:

```bash
godot4 --path .
```

## Project structure

| Folder | Contents |
|---|---|
| `autoloads/` | Global singletons: game events, player and shopkeeper inventories |
| `data_classes/` | Reusable classes: `Item`, `InventoryComponent`, `EquipmentComponent` |
| `resources/items/` | Item definitions (`.tres`) |
| `games/` | Minigame logic |
| `views/` | Full-screen views: sandbox, shop, slot machine |
| `levels/` | Explorable levels |
| `player/`, `npcs/` | Player character and NPCs |
| `ui/` | HUD, inventory screen, equipment slots |
| `assets/` | Sprites, icons, animations |

## Tech

- Godot 4.7, GDScript (statically typed)
- Forward+ renderer, Jolt Physics
- Linted with [gdtoolkit](https://github.com/Scony/godot-gdscript-toolkit) (`gdlint`)
