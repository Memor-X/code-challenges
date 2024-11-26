# --- [Add Two Numbers](https://leetcode.com/problems/add-two-numbers/description/) --- ![Medium Static Badge](https://img.shields.io/badge/Medium-ffb800?style=for-the-badge)


Language: ![Ruby Static Badge](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=FFFFFF&labelColor=CC342D)

You are given two **non-empty** linked lists representing two non-negative integers. The digits are stored in **reverse order**, and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

 

**Example 1:**

> **Input:** l1 = [2,4,3], l2 = [5,6,4]<br>
> **Output:** [7,0,8]<br>
> **Explanation:** 342 + 465 = 807.


**Example 2:**

> **Input:** l1 = [0], l2 = [0]<br>
> **Output:** [0]


**Example 3:**

> **Input:** l1 = [9,9,9,9,9,9,9], l2 = [9,9,9,9]<br>
> **Output:** [8,9,9,9,0,0,0,1]
 

**Constraints:**

- The number of nodes in each linked list is in the range [1, 100].
- `0 <= Node.val <= 9`
- It is guaranteed that the list represents a number that does not have leading zeros.

## --- Leetcode Stats ---

- **Runtime:** 10 ms
- **Memory Usage:** 211.8 MB

## --- Unit Testing ---

Code Coverage Req: 90%

| File | No. of Tests | Code Coverage |
| :--- | :---: | ---: |
| LocalLib.rb | 5 | <span style="color:green">100%</span> |
| ListNode.rb | 6 | <span style="color:green">100%</span> |
| **Total** | 11 | <span style="color:green">100%</span> |
