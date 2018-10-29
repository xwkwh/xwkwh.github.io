---
title: Leetcode 28 Implement strStr()
date: 2018-06-10 20:11:20
categories: Leetcode
tags:
	- Leetcode
	
---

## Leetcode 28 Implement strStr()  

strStr 就是返回在字符串中出现目标字符串的第一个index

eg:

```
Input: haystack = "hello", needle = "ll"
Output: 2
Input: haystack = "aaaaa", needle = "bba"
Output: -1
```

遍历俩个字符串，随着haystack的遍历，每一次都循环比较needle是否相等，若比较到needle的长度则返回；若中途有不匹配的，直接跳出循环

Go solution1:  易于理解，在遍历前进行特殊情况的判断

```go
    hlen := len(haystack)
	nlen := len(needle)
	if nlen == 0  {
		return 0
	}
	if hlen >= nlen {
		for i := 0; i <=hlen-nlen; i++ {
			j := 0
			for j < nlen {
				if haystack[i+j] != needle[j] {
					break
				}
				j++
			}
			if j == nlen {
				return i
			}
		}
	}
	return -1
```

Go solution 2: 改进

```go
for i:=0; ;i++ {
		for j:=0; ;j++ {
			if j == len(needle) {
				return i
			}
			if i+j == len(haystack) {
				return -1
			}
			if haystack[i+j] != needle[j] {
				break
			}
		}
	}
}
```



