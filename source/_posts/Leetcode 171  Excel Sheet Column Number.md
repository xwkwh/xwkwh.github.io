---
title: Leetcode 171  Excel Sheet Column Number
date: 2018-06-10 20:17:20
categories: Leetcode
tags:
	- Leetcode
	
---

## Leetcode 171  Excel Sheet Column Number   

把excel 的sheet表示成数字

For example

```
  A -> 1
  B -> 2
  C -> 3
  ...
  Z -> 26
  AA -> 27
  AB -> 28 
```

类似与二进制转十进制，相当于26进制转换

Go:

```go
func titleToNumber(s string) int {
	l := len(s)
	res := 0
	for i :=0 ; i <l ; i++ {
		num := (int)(s[i]-'A'+1)
		res = num + res * 26
	}
	return  res
}
```



