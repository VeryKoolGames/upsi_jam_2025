# upsi_jam_2025

A puzzle game created for a game jam using Godot 4.4.

## About

upsi_jam_2025 is a shape-matching puzzle game where players control a character and interact with falling shapes. The game features a scoring system and multiple game modes to challenge players with different difficulty levels.

## Features

- **Three Game Modes:**
  - **Normal Mode**: Standard gameplay experience
  - **Hardcore Mode**: Increased difficulty for experienced players
  - **Infinity Mode**: Endless gameplay for high score chasers

- **Dynamic Gameplay**: Shape spawning system with particle effects
- **Score Tracking**: Keep track of your highest scores
- **Smooth Controls**: Responsive player movement and rotation mechanics

## Controls

- **W/A/S/D**: Move Up/Left/Down/Right
- **Q/E**: Rotate Left/Right
- **Space**: Shake action
- **Escape**: Pause game

## Getting Started

### Prerequisites

- [Godot Engine 4.4](https://godotengine.org/download) or later
- OpenGL Compatibility renderer support

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/VeryKoolGames/upsi_jam_2025.git
   ```

2. Open the project in Godot Engine:
   - Launch Godot
   - Click "Import"
   - Navigate to the cloned repository
   - Select the `project.godot` file
   - Click "Import & Edit"

3. Run the game:
   - Press F5 or click the "Play" button in the Godot editor

## Project Structure

```
upsi_jam_2025/
├── Fonts/          # Game fonts
├── Resources/      # Game resources and assets
├── Scenes/         # Godot scene files
│   ├── Enemy/      # Enemy-related scenes
│   ├── Game/       # Main game scenes (Normal, Hardcore, Infinity, Start Menu)
│   ├── Particles/  # Particle effect scenes
│   ├── Player/     # Player character scenes
│   ├── Shapes/     # Shape object scenes
│   ├── UI/         # User interface scenes
│   └── Utils/      # Utility scenes
├── Scripts/        # GDScript files
│   └── Autoloads/  # Global autoload scripts (Events, PlayerScore)
├── Shaders/        # Custom shader files
├── Sounds/         # Audio files
└── Sprites/        # Sprite and image assets
```

## Development

This project uses:
- **Engine**: Godot 4.4
- **Scripting Language**: GDScript
- **Rendering**: GL Compatibility mode
- **Resolution**: 1920x1080 (viewport stretch mode)

### Key Scripts

- `Events.gd`: Global event system autoload
- `PlayerScore.gd`: Score management autoload
- `shape_spawner.gd`: Handles spawning of game shapes
- `player_movement.gd`: Player character control logic
- `GameModeEnum.gd`: Game mode definitions

## Credits

Created by VeryKoolGames

## License

See the repository for license information.
