# --- [Two Sum](https://leetcode.com/problems/two-sum/description/) --- ![Easy Static Badge](https://img.shields.io/badge/Easy-1cb8b8?style=for-the-badge)

Language: ![Ruby Static Badge](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=FFFFFF&labelColor=CC342D)

Given an array of integers `nums` and an integer `target`, return *indices of the two numbers such that they add up to `target`*.

You may assume that each input would have ***exactly* one solution**, and you may not use the *same* element twice.

You can return the answer in any order.

**Example 1:**

> **Input:** nums = [2,7,11,15], target = 9</br>
> **Output:** [0,1]</br>
> **Explanation:** Because nums[0] + nums[1] == 9, we return [0, 1].

**Example 2:**

> **Input:** nums = [3,2,4], target = 6</br>
> **Output:** [1,2]

**Example 3:**

> **Input:** nums = [3,3], target = 6</br>
> **Output:** [0,1]

**Constraints:**

- `2 <= nums.length <= 104`
- `-109 <= nums[i] <= 109`
- `-109 <= target <= 109`
- **Only one valid answer exists.**

## --- Leetcode Stats ---

- **Runtime:** 2334 ms
- **Memory Usage:** 211.8 MB

## --- Unit Testing ---

Code Coverage Req: 90%

| File | No. of Tests | Code Coverage |
| :--- | :---: | ---: |
| LocalLib.rb | 3 | <span style="color:green">100%</span> |
| **Total** | 3 | <span style="color:green">100%</span> |
