# Godot 4 Boat Game Implementation Plan

## Project Overview
A simple boat survival game where players navigate an ocean, manage health, and respawn after sinking.

## Phase 1: Engine Setup & Project Structure
- [ ] Download Godot 4 (standard version)
- [ ] Create new Godot project
- [ ] Set up folder structure in FileSystem dock:
  - `Scenes/` - Main menu, world, boat scenes
  - `Scripts/` - GDScript logic files
  - `Assets/` - Models, Textures, Audio subfolders
  - `UI/` - Menus, health bars, HUD elements

## Phase 2: Player Boat Creation
- [ ] Create `PlayerBoat.tscn` scene
  - Root: CharacterBody3D node
  - Child: MeshInstance3D with cube/rectangle mesh (boat hull)
  - Child: CollisionShape3D matching hull dimensions
- [ ] Create `player_boat.gd` script
  - Implement basic movement (W/S for forward/backward)
  - Implement turning (A/D for left/right)
  - Handle physics-based movement

## Phase 3: Health & Survival Systems
- [ ] Define game state variables:
  - `max_health = 100`
  - `current_health = 100`
  - `is_sinking = false`
  - `spawn_point = Vector3(0, 0, 0)`
- [ ] Implement damage system:
  - `take_damage(amount)` function
  - Health reduction logic
- [ ] Implement sinking mechanic:
  - Check `current_health <= 0`
  - Set `is_sinking = true`
  - Disable movement controls
  - Gradually lower boat Y position
- [ ] Implement respawn system:
  - Timer after sinking starts
  - Reset health to 100
  - Teleport to spawn_point
  - Reset `is_sinking = false`

## Phase 4: World Environment
- [ ] Create `main_world.tscn` scene
- [ ] Add ocean surface:
  - MeshInstance3D with plane mesh
  - Blue color/material
  - Scale to large dimensions
- [ ] Instantiate player boat:
  - Add PlayerBoat instance to world
  - Position on water surface
- [ ] Add camera system:
  - Camera3D as child of boat
  - Third-person perspective positioning
  - Smooth follow behavior

## Phase 5: UI & HUD
- [ ] Create CanvasLayer in main_world.tscn
- [ ] Add health bar:
  - ProgressBar node
  - Position on screen (top-left or similar)
  - Style configuration
- [ ] Create HUD script:
  - Link to player boat health variable
  - Update health bar value each frame
  - Handle visual feedback for damage/sinking

## File Structure Reference
```
open-water/
├── Scenes/
│   ├── PlayerBoat.tscn
│   ├── main_world.tscn
│   └── (future: main_menu.tscn)
├── Scripts/
│   ├── player_boat.gd
│   └── (future: hud_controller.gd)
├── Assets/
│   ├── Models/
│   ├── Textures/
│   └── Audio/
└── UI/
    └── (future: menu scenes)
```

## Implementation Notes
- Use CharacterBody3D for physics-based boat movement
- Keep mesh simple (box shapes) for initial testing
- Health bar should update in `_process()` or via signals
- Respawn delay of 3-5 seconds recommended
- Camera offset needs testing for good visibility

## Next Steps
1. Start with Phase 1 - download Godot and set up project
2. Progress through phases sequentially
3. Test each phase before moving to next
4. Keep scripts simple and readable
