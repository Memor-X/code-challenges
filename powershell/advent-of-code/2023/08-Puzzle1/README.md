# --- Day 8: Haunted Wasteland ---

Language: ![Powershell Static Badge](https://img.shields.io/badge/Powershell-012456?style=for-the-badge&logo=powershell&logoColor=012456&labelColor=FFFFFF)

You're still riding a camel across Desert Island when you spot a sandstorm quickly approaching. When you turn to warn the Elf, she disappears before your eyes! To be fair, she had just finished warning you about **ghosts** a few minutes ago.

One of the camel's pouches is labeled "maps" - sure enough, it's full of documents (your puzzle input) about how to navigate the desert. At least, you're pretty sure that's what they are; one of the documents contains a list of left/right instructions, and the rest of the documents seem to describe some kind of **network** of labeled nodes.

It seems like you're meant to use the **left/right** instructions to **navigate the network**. Perhaps if you have the camel follow the same instructions, you can escape the haunted wasteland!

After examining the maps for a bit, two nodes stick out: `AAA` and `ZZZ`. You feel like `AAA` is where you are now, and you have to follow the left/right instructions until you reach `ZZZ`.

This format defines each **node** of the network individually. For example:

```text
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
```

Starting with `AAA`, you need to **look up the next element** based on the next left/right instruction in your input. In this example, start with `AAA` and go **right** (`R`) by choosing the right element of `AAA`, `**CCC**`. Then, `L` means to choose the **left** element of `CCC`, `**ZZZ**`. By following the left/right instructions, you reach `ZZZ` in `**2**` steps.

Of course, you might not find `ZZZ` right away. If you run out of left/right instructions, repeat the whole sequence of instructions as necessary: `RL` really means `RLRLRLRLRLRLRLRL...` and so on. For example, here is a situation that takes `**6**` steps to reach `ZZZ`:

```text
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
```

Starting at `AAA`, follow the left/right instructions. **How many steps are required to reach `ZZZ`?**

## --- Unit Testing ---

Code Coverage Req: 90%

| File | No. of Tests | Code Coverage |
| :--- | :---: | ---: |
| LocalLib.rb | 0 | <span style="color:green">100%</span> |
| **Total** | 0 | <span style="color:green">100%</span> |

## --- Approach ---

1. Load data into variables
    - line 1 separated out to separate path variable
    - loop though starting from line 3 create hash object of arrays in format of `KEY (ARR[0], ARR[1])`
2. set
    - current steps taken to 0
    - current index of path to 0
    - current node to AAA
3. while current node is not ZZZ
    1. if path index is greater than the length of the path, reset path index to 0
    2. get path step at path index
    3. convert path step to integer (L = 0, R = 1)
    4. set current node to node stored at index of path step integer