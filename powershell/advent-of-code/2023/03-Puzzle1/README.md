# --- [Day 3: Gear Ratios](https://adventofcode.com/2023/day/3) ---

Language: ![Powershell Static Badge](https://img.shields.io/badge/Powershell-012456?style=for-the-badge&logo=powershell&logoColor=012456&labelColor=FFFFFF)

## --- Part One ---
You and the Elf eventually reach a gondola lift station; he says the [gondola lift](https://en.wikipedia.org/wiki/Gondola_lift) will take you up to the **water source**, but this is as far as he can bring you. You go inside.

It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.

"Aaah!"

You turn around to see a slightly-greasy Elf with a wrench and a look of surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working right now; it'll still be a while before I can fix it." You offer to help.

The engineer explains that an engine part seems to be missing from the engine, but nobody can figure out which one. If you can **add up all the part numbers** in the engine schematic, it should be easy to work out which part is missing.

The engine schematic (your puzzle input) consists of a visual representation of the engine. There are lots of numbers and symbols you don't really understand, but apparently **any number adjacent to a symbol**, even diagonally, is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)

Here is an example engine schematic:

```text
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
```

In this schematic, two numbers are **not** part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is 4361.

Of course, the actual engine schematic is much larger. **What is the sum of all of the part numbers in the engine schematic?**

## --- Unit Testing ---

Code Coverage Req: 90%

| File | No. of Tests | Code Coverage |
| :--- | :---: | ---: |
| LocalLib.ps1 | 0 | <span style="color:green">100%</span> |
| **Total** | 0 | <span style="color:green">100%</span> |

## --- Approach ---

1. Load data into array
2. loop though each line
    1. find number by looking for first and last digit and recording positions
    2. generate string by collecting strings from
        - previous line starting at position before current number of length of current number + 2
        - character in front of current number (skip if at start of the line)
        - next starting at position before current number of length of current number + 2
    3. replace all . with nothing
    4. if string is greater than 0, part number to array
3. loop though array of part numbers, summing together
