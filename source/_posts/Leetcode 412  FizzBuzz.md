---
title: Leetcode 412  FizzBuzz
date: 2018-06-11 21:17:20
categories: Leetcode
tags:
	- Leetcode
	
---

## Leetcode 412  FizzBuzz

* 题目：输入一个数n，输出1-n，如果n能被3整除，输出Fizz；能被5整除，输出Buzz；同时能被整除，输出FizzBuzz
*  思路：直接遍历，先判断能被15整除，再判断能被3/5整除

```go
func fizzBuzz(n int) []string {
	res := make([]string, n)
	for i := range res {
		x := i + 1
		switch {
		case x%15 == 0:
			res[i] = "FizzBuzz"
		case x%5 == 0:
			res[i] = "Buzz"
		case x%3 == 0:
			res[i] = "Fizz"
		default:
			res[i] = strconv.Itoa(x)
		}
	}
	return res
}
```

