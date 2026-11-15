# Tower of Easy Parkour

Tower of Easy Parkour is a multiplayer parkour game built in **Unreal Editor for Fortnite (UEFN)** using **Verse** and **Scene Graph**. Players race to reach the top of a tower while avoiding obstacles and adapting to a course that changes over time.

![View of the parkour course from the starting area](assets/InGameScreenshot1.PNG)

## Play the Game

**Fortnite island code:** `2720-1036-0492`

Open Fortnite, go to **Search**, and enter the island code to play Tower of Easy Parkour.

## Gameplay

- **Reach the top:** Climb the parkour course to complete it.
- **Avoid obstacles:** Touching neon-colored hazards eliminates the player and sends them back to the start. Falling also means starting again from the bottom.
- **Race against the clock:** A countdown tracks the time remaining for the current course. When players reach the top, the countdown speeds up; the more players who finish, the faster it runs.
- **Explore changing courses:** Every round, one of **five** courses is selected at random. When the timer reaches zero, the current course is removed, all players return to the starting area, and a new course is spawned in the same location.

![Looking up at the parkour course](assets/InGameScreenshot2.PNG)

## Technology

| Technology | Use in this project |
| --- | --- |
| **UEFN** | Building the Fortnite island and configuring the game environment. |
| **Verse** | Implementing gameplay behavior, the course rotation system, and player-facing information. |
| **Scene Graph** | Organizing and managing the parkour courses so that the active course can be removed and another spawned. |

## Gameplay Preview

[Watch gameplay footage on YouTube](https://youtu.be/syjvCpAUobQ) 

## Project Documentation

This repository contains the Verse source code and documentation describing how the gameplay systems work. The key technical feature is the **dynamic course rotation system**, which replaces the active course while resetting players for the next round.

## More Games

Explore my other Fortnite projects on [Fortnite.gg](https://fortnite.gg/creator/creativenight).
