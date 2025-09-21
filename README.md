# Sokoban-in-Assembly

A RISC-V Assembly implementation of the classic Sokoban game, with added enhancements:

- **Resizable Board:** Players can set custom board dimensions.
- **Difficulty Levels:** Adjust the number of boxes and targets.
- **Multi-player Mode:** Competitive gameplay with leaderboard rankings.

## Features

### 1. Increase Difficulty
The game allows players to select the number of boxes and targets.  
- The difficulty value is stored in memory (`difficulty`) and used to generate the board dynamically.
- Boxes and targets are placed in separate arrays in memory (`box` and `target`).
- The board is constructed by checking each square for box or target presence.
- Each character and object placement ensures no overlaps and valid positions.

### 2. Multi-player Mode
Players can compete by taking turns on the same board.  
- The number of players is stored in memory (`num_players`).
- A `static_seed` ensures that all players start with the same board layout.
- After each player completes the board, the number of moves they took is recorded in the `score` array.
- A leaderboard ranks players based on their performance.

### 3. Random Number Generation
- Random positions for boxes, targets, and characters are generated using an LCG (Linear Congruential Generator) function (`lcg_rand`).
- `seed` updates dynamically with each random number generation, while `static_seed` maintains the initial board layout for multi-player mode.

## How It Works

1. **Game Setup**  
   - Player inputs board width, height, difficulty, and number of players.
   - The program validates input to ensure minimum board dimensions and valid numbers.

2. **Object Creation**  
   - Boxes, targets, and characters are generated using dedicated functions (`createBox`, `createTarget`, `createCharacter`).
   - All positions are checked to avoid overlapping objects and corners of the board.

3. **Board Construction**  
   - The `construct_board` function iterates over the board grid and prints walls, boxes, targets, and characters in their correct positions.

4. **Gameplay Loop**  
   - Each player takes turns to move the character and push boxes.
   - Moves are counted for each player and saved in the `score` array.
   - The game ends when all boxes are pushed to targets.

5. **Leaderboard Generation**  
   - After all players finish, the leaderboard displays players ranked by the number of moves taken to complete the board.

## Controls

- `w` – Move up  
- `a` – Move left  
- `s` – Move down  
- `d` – Move right  

## Notes

- Minimum board dimensions: 3x3.
- Multiple players share the same board layout in competitive mode.
- The LCG ensures repeatable board generation for fair multi-player competition.

## References

- `lcg_rand` function reference is implemented at **line 1992** in the source code.
