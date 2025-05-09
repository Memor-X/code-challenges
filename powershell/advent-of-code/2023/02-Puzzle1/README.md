# --- [Day 2: Cube Conundrum](https://adventofcode.com/2023/day/2) ---

Language: ![Powershell Static Badge](https://img.shields.io/badge/Powershell-012456?style=for-the-badge&logo=powershell&logoColor=012456&labelColor=FFFFFF)

## --- Part One ---
You're launched high into the atmosphere! The apex of your trajectory just barely reaches the surface of a large island floating in the sky. You gently land in a fluffy pile of leaves. It's quite cold, but you don't see much snow. An Elf runs over to greet you.

The Elf explains that you've arrived at **Snow Island** and apologizes for the lack of snow. He'll be happy to explain the situation, but it's a bit of a walk, so you have some time. They don't get many visitors up here; would you like to play a game in the meantime?

As you walk, the Elf shows you a small bag and some cubes which are either red, green, or blue. Each time you play this game, he will hide a secret number of cubes of each color in the bag, and your goal is to figure out information about the number of cubes.

To get information, once a bag has been loaded with cubes, the Elf will reach into the bag, grab a handful of random cubes, show them to you, and then put them back in the bag. He'll do this a few times per game.

You play several games and record the information from each game (your puzzle input). Each game is listed with its ID number (like the 11 in Game 11: ...) followed by a semicolon-separated list of subsets of cubes that were revealed from the bag (like 3 red, 5 green, 4 blue).

For example, the record of a few games might look like this:

```text
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
```

In game 1, three sets of cubes are revealed from the bag (and then put back again). The first set is 3 blue cubes and 4 red cubes; the second set is 1 red cube, 2 green cubes, and 6 blue cubes; the third set is only 2 green cubes.

The Elf would first like to know which games would have been possible if the bag contained **only 12 red cubes, 13 green cubes, and 14 blue cubes**?

In the example above, games 1, 2, and 5 would have been **possible** if the bag had been loaded with that configuration. However, game 3 would have been **impossible** because at one point the Elf showed you 20 red cubes at once; similarly, game 4 would also have been **impossible** because the Elf showed you 15 blue cubes at once. If you add up the IDs of the games that would have been possible, you get **8**.

Determine which games would have been possible if the bag had been loaded with only 12 red cubes, 13 green cubes, and 14 blue cubes. **What is the sum of the IDs of those games?**

## --- Unit Testing ---

Code Coverage Req: 90%

| File | No. of Tests | Code Coverage |
| :--- | :---: | ---: |
| LocalLib.ps1 | 6 | <span style="color:green">100%</span> |
| **Total** | 6 | <span style="color:green">100%</span> |

## --- Approach ---

- Importing Data
    1. create an empty hash object to store the game data
    2. create a hash object with red, green and blue as keys with values of 0 to use as a template
    3. for each line of input
        1. split the string from the :
        2. remove "Game " from the resulting `array[0]`, trim any whitespace and store as the game ID
        3. split `array[1]` by the ; to create an array of sets
        4. for each set
            1. clone the rgb hash template made at the start
            2. split the set by , to get an array of cubes
            3. for each cube
                1. trim and split the sub by the single space between. the result should be a number at `array[0]` and the color at `array[1]`
                2. update the cloned template using `array[1]` as the key and `array[0]` as the value, casting `array[0]` as an integer
            4. add the cloned template to game data hash object

- Solution
    1. create an empty array to store possible games
    2. for each game
        1. create a hash object with red, blue and green as keys who's values are 0
        2. for each set
            1. for each color
                1. if the value of the color is greater than what is in the hash object, update the number
        3. store the resulting max values
        4. check the max values against the criteria
        5. if all max values are equal too or under the criteria, add the game id to the possible games array
    3. loop though array of possible games, summing together
