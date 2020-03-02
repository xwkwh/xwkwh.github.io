---
title: Redis Bitmaps 
date: 2018-11-06 19:00:00
categories: redis
tags: redis
---



### Bitmaps

Bitmaps 在redis中本身不是数据结构，实际上它就是字符串，但是他可以对字符串的位进行操作

bitmaps单独提供了一套命令和string的使用不太相同

### 命令

1. 设置值

   ```redis
   setbit key offset value
   ```

   offset为相对偏移量，返回的值为该位原来的值

2. 获取值

   ```redis
   getbit key offset
   ```

   可以应用于网站用户登陆，返回0表示未登陆过

3. 统计指定范围值为1的个数

   ```redis
   bitcount key [start][end]
   ```

   可以应用于用户访问数量 和 时长

4. bitmaps之间的运算

   ```redis
   bitop op destkey key[key....]
   ```

   bitop是一个复合操作，它可以做多个Bitmaps的and（交集）、or（并 集）、not（非）、xor（异或）操作并将结果保存在destkey中

   eg: 计算几天内用户任意一天访问过的数量，可以把这几天的key取and

   `bitop and unique:users:and:2016-04-04_03 unique:users:2016-04-03 unique:users:2016-04-03`

5. 计算bitmaps中第一个值为targeBit的偏移量

   ```redis
   bitpos key targetBit [start] [end]
   ```

   eg: 计算当前访问的用户最小id

   `bitpos unique:users:2016-04-04 1`

   `(integer) 1`

### 

