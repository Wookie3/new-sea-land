# AGENTS.md - Godot 4 Open Water Project

## Build & Test Commands

### Running the Game
```bash
# Run the game from command line
godot --path open-water

# Run in editor mode
godot --path open-water --editor
```

### Testing
- Godot projects don't have traditional unit tests
- Testing is done by running scenes directly in the editor
- To test a specific scene: Open it in Godot Editor, press F6 (Run Current Scene)
- Use `print()` statements for debugging - visible in Godot's Output panel

### No Linting
- GDScript is dynamically typed with optional type hints
- No linting command - Godot Editor provides real-time error checking

## Code Style Guidelines

### Language & Engine
- **Language**: GDScript (Godot 4.x)
- **Engine**: Godot 4.x (not .NET version)
- **Indentation**: Use tabs (Godot convention, not spaces)

### Naming Conventions
- **Files**: `snake_case.gd` (e.g., player_boat.gd, hud_controller.gd)
- **Scenes**: `PascalCase.tscn` (e.g., PlayerBoat.tscn, main_world.tscn)
- **Classes/Folders**: `PascalCase` (e.g., Scripts/, Scenes/, Assets/)
- **Functions**: `snake_case()` (e.g., take_damage(), respawn())
- **Variables**: `snake_case` (e.g., current_health, spawn_point)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., SPEED, TURN_SPEED, RESPAWN_TIME)
- **Private functions**: Prefix with underscore `_helper_function()`
- **Godot lifecycle methods**: Always use underscore prefix: `_ready()`, `_physics_process()`, `_process()`

### File Structure
```
open-water/
├── Scenes/          # .tscn files (PascalCase)
│   ├── PlayerBoat.tscn       # Player boat with red/gray hull
│   ├── main_world.tscn        # Main game world with two regions
│   ├── Port.tscn              # Reusable dock structure
│   ├── AridIsland.tscn        # Sandy arid island base
│   ├── TropicalIsland.tscn    # Green tropical island base
│   ├── AridIslandWithPort.tscn    # Arid island + port
│   └── TropicalIslandWithPort.tscn # Tropical island + port
├── Scripts/         # .gd files (snake_case)
├── Assets/
│   ├── Models/
│   ├── Textures/
│   │   └── water.gdshader    # Procedural water shader
│   └── Audio/
└── UI/             # CanvasLayer, control nodes
```

### Imports & Dependencies
- No explicit import statements needed (Godot classes are global)
- Reference child nodes using `@onready var node = $NodePath`
- Reference external scenes: `preload("res://path/to/scene.tscn")`

### Type Hints
- Use type hints: `func _get_wave_height(x: float, z: float, t: float) -> float:`
- Optional but encouraged for clarity
- Built-in types: `Vector3`, `float`, `bool`, `int`, `String`, `Node`

### Formatting
- Tabs for indentation, spaces around operators, no trailing whitespace

### Node References
- Use `@onready` for child node references (cached after `_ready()`):
  ```gdscript
  @onready var camera = $Camera3D
  @onready var health_bar = $ProgressBar
  ```
- Use `$NodePath` for direct children, `get_node("path")` for deeper paths

### Exposed Variables
- Use `@export` for editor-exposed variables (appears in Inspector panel):
  ```gdscript
  @export var player_path: NodePath
  @export var speed: float = 10.0
  ```

### Constants
- Define at class top: `const SPEED = 10.0`
- Use `Vector3.ZERO` instead of `Vector3(0, 0, 0)`

### Error Handling
- No try-catch exceptions - use simple if statements for validation:
  ```gdscript
  if not player: return
  if is_sinking: return
  ```
- Early returns preferred, use `print()` for debugging

### Physics & Movement
- Use `CharacterBody3D` for physics-based characters (boats)
- Override `_physics_process(delta)` for physics, `move_and_slide()` for movement
- Set velocity components directly: `velocity.x = forward.x * speed`

### Godot Lifecycle Methods
- `_ready()`: Node added to scene
- `_physics_process(delta)`: Every physics frame (fixed timestep)
- `_process(delta)`: Every frame (rendering/UI)

### Shaders
- Shader files: `name.gdshader` in Assets/Textures/
- `shader_type spatial;` for 3D materials: `void vertex() {}`, `void fragment() {}`

### Comments
- Use `#` for single-line comments, minimal inline comments, prefer self-documenting code

### UI & HUD
- Use `Control` nodes with `CanvasLayer` for HUD elements
- Link HUD to game state in `_process()`:
  ```gdscript
  func _process(delta):
      health_bar.value = player.current_health
  ```

### Project Configuration
- Main scene: Set in `project.godot` under `[application]` -> `run/main_scene`
- Current main scene: `"res://Scenes/main_world.tscn"`

### Scene Files (.tscn)
- Don't manually edit .tscn files unless necessary
- Use Godot Editor to modify scenes
- .tscn files use Godot's text-based scene format

## Key Existing Patterns
- Boat uses `CharacterBody3D` with wave physics simulation
- Wave calculations match between shader (`water.gdshader`) and script (`player_boat.gd`)
- Health/damage/sink/respawn cycle is core mechanic
- Camera is child of boat with FOV speed effects
- Simple arcade controls: WASD movement, Space for debug damage
- World split into two regions: Arid (player spawn) and Tropical (enemy)
- Islands use cylinder meshes for simple terrain with collision
- Port scene is reusable, can be parented to any island type
- StaticBody3D for islands (non-moving objects with collision)

## When Making Changes
1. Always test changes by running the scene in Godot Editor (F6)
2. Keep game logic in Scripts/ folder
3. Use existing patterns: `@onready`, `_physics_process`, type hints
4. Maintain simple arcade gameplay feel
5. Add new scenes to Scenes/ folder with PascalCase naming
6. Update this file if introducing new patterns or conventions