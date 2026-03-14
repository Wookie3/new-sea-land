# Open Water - Godot Project

This project was scaffolded via the Gemini CLI.

## Instructions

1.  **Open Godot 4**: Launch the Godot Engine (version 4.x).
2.  **Import Project**: Click "Import" and select the `project.godot` file in the `open-water` directory.
3.  **Run**: Press the "Run Project" (Play) button in the top right corner.

## Controls

-   **W / S**: Move Forward / Backward
-   **A / D**: Turn Left / Right
-   **Space**: Take Damage (Debug)

## World Layout

The world is divided into two regions:

1.  **Arid Region** (Player Starting Area)
    - Sandy arid islands with rocks
    - Contains the player's starting port
    - Located around player spawn point

2.  **Tropical Region** (Enemy Territory)
    - Green tropical islands with trees
    - Contains enemy port and base
    - Located ~200 units SOUTH of player spawn

## Project Structure

-   `Scenes/`: Contains main world, player boat, islands, and port scenes
    - `AridIsland.tscn`: Sandy arid island base
    - `TropicalIsland.tscn`: Green tropical island base
    - `Port.tscn`: Reusable dock structure
    - `AridIslandWithPort.tscn`: Arid island with port
    - `TropicalIslandWithPort.tscn`: Tropical island with port
-   `Scripts/`: Contains `player_boat.gd` and `hud_controller.gd`.
-   `Assets/Textures/`: Contains water shader
-   `project.godot`: Main configuration file
