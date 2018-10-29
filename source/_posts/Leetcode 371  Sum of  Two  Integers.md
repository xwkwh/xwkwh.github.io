---
title: Leetcode 371  Sum of  Two  Integers
date: 2018-06-11 20:17:20
categories: Leetcode
tags:
	- Leetcode
	
---

## Leetcode 371  Sum of  Two  Integers

>Calculate the sum of two integers a and b, but you are not allowed to use the operator `+` and `-`.

> Example:

> Given a = 1 and b = 2, return 3.

题目要求不能使用+和-，就可以想到是用位运算解决

* ^ 异或，相当于无进位的加法，即俩个位置不一样即为1，否则为0
* & 与，求进位，进位的产生是俩个位置上都是1，即1&1=1
* << 由于是进位，还得将其向左移一位，
* 直到a==0时，返回b即可

```go
func getSum(a int, b int) int {
	for a != 0 {
		a, b = (a&b)<<1, a^b
	}
	return b
}
```

