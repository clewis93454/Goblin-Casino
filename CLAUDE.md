# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Goblin Casino is a fantasy-themed casino game built around a collection of gambling minigames (cards, slots, roulette, etc.). It's a personal learning project for the user to learn Godot — treat it as such (see "Working with Claude" below).

Engine: Godot 4.7, GDScript, Forward Plus renderer, Jolt Physics. Main scene is `game.tscn` / `game.gd` (currently a placeholder `Node2D`).

## Roadmap

`docs/ROADMAP.md` is the guiding structure for all changes. Read it before answering architecture questions or proposing changes, keep work consistent with its milestones, decisions, and requirements, and point out when a request conflicts with it or jumps ahead of the milestone order. Don't assume answers to its open decisions.

## Running the Project

There is no separate build step — Godot projects run directly from the editor or CLI.

- Editor: open `project.godot` in Godot 4.7 and press F5 (or the play button) to run the main scene.
- CLI (if the `godot4` executable is on PATH): `godot4 --path .` to run, `godot4 -e --path .` to open the editor.

## Code Conventions

- Use strict, explicit typing everywhere in GDScript — type-annotate variables, function parameters, and return types (e.g. `func foo(x: int) -> void:`). Avoid untyped/dynamically-inferred declarations.
- Line endings are normalized to LF for text files (`.gitattributes`); files use UTF-8 (`.editorconfig`).

## Working with Claude

- This project exists for the user to learn Godot. Default to **guiding, not doing**: explain the relevant Godot concepts/APIs and suggest an approach, and let the user write the implementation themselves. Step in and implement directly mainly for review, debugging, or when explicitly asked to just do it.
- Only commit when explicitly asked to.
- For questions about Godot behavior, APIs, or best practices, treat the official documentation at https://docs.godotengine.org/en/stable/ as the source of truth — consult it (e.g. via WebFetch) rather than relying on memory, and prefer it over other tutorials/blogs when they conflict.
