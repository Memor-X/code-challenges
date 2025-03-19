# --- [Day 7: Camel Cards](https://adventofcode.com/2023/day/7) ---

Language: ![Powershell Static Badge](https://img.shields.io/badge/Powershell-012456?style=for-the-badge&logo=powershell&logoColor=012456&labelColor=FFFFFF)

## --- Part Two ---
To make things a little more interesting, the Elf introduces one additional rule. Now, `J` cards are [jokers](https://en.wikipedia.org/wiki/Joker_(playing_card)) - wildcards that can act like whatever card would make the hand the strongest type possible.

To balance this, **`J` cards are now the weakest** individual cards, weaker even than `2`. The other cards stay in the same order: `A`, `K`, `Q`, `T`, `9`, `8`, `7`, `6`, `5`, `4`, `3`, `2`, `J`.

`J` cards can pretend to be whatever card is best for the purpose of determining hand type; for example, `QJJQ2` is now considered **four of a kind**. However, for the purpose of breaking ties between two hands of the same type, `J` is always treated as `J`, not the card it's pretending to be: `JKKK2` is weaker than `QQQQ2` because `J` is weaker than `Q`.

Now, the above example goes very differently:

```text
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
```

- `32T3K` is still the only **one pair**; it doesn't contain any jokers, so its strength doesn't increase.
- `KK677` is now the only **two pair**, making it the second-weakest hand.
- `T55J5`, `KTJJT`, and `QQQJA` are now all **four of a kind**! `T55J5` gets rank 3, `QQQJA` gets rank 4, and `KTJJT` gets rank 5.

With the new joker rule, the total winnings in this example are `**5905**`.

Using the new joker rule, find the rank of every hand in your set. **What are the new total winnings?**

## --- Unit Testing ---

Code Coverage Req: 90%

| File | No. of Tests | Code Coverage |
| :--- | :---: | ---: |
| LocalLib.rb | 42 | <span style="color:green">100%</span> |
| **Total** | 42 | <span style="color:green">100%</span> |

## --- Approach ---

- updated card integer so that J = 1 instead of 11
- when sorting hand categories
  - removed all the J and get the difference between hand sizes to get number of J's
  - add the number of J's when counting how many of each card
