---
title: Sed Learning
date: 2018-11-01 19:12:35
categories: linux
tags: linux
---


## Sed Learning

### 用s命令替换

- eg: ` sed "s/my/xwk's/g" test.txt `

  s代表替换，/my/匹配my /xwk's/将匹配的替换为xwk's  g表示替换所有匹配

  *再注意：*上面的sed并没有对文件的内容改变，只是把处理过后的内容输出，如果你要写回文件，你可以使用重定向，如
  `sed "s/my/xwk's/g" test.txt > sedToXwk.txt ` （>> 可以追加到文件末尾）
  或者 使用 -i 参数直接修改文件内容
  `sed -i "s/my/xwk's/g" test.txt ` 

- 附：正则基础

  - `^` 表示一行的开头。如：`/^#/` 以#开头的匹配。

  - `$` 表示一行的结尾。如：`/}$/` 以}结尾的匹配。

  - `\<` 表示词首。 如：`\<abc` 表示以 abc 为首的詞。

  - `\>` 表示词尾。 如：`abc\>` 表示以 abc 結尾的詞。

  - `.` 表示任何单个字符。

  - `*` 表示某个字符出现了0次或多次。

  - `[ ]` 字符集合。 如：`[abc]` 表示匹配a或b或c，还有 `[a-zA-Z]` 表示匹配所有的26个字符。如果其中有^表示反，如 `[^a]` 表示非a的字符

  -  eg: 

    ``` shell
    <b>This</b> is what <span style="text-decoration: underline;">I</span> meant. Understand?
    sed "s/<[^>]*>//g" HTML.txt
    This is what I meant. Understand?
    ```

- 指定替换内容

  ```she
  sed "3s/my/your/g" pets.txt
  替换第三行my
  sed "3,6s/my/your/g" pets.txt
  替换第3到6行my
  sed "s/my/your/3" pets.txt
  替换每行的第三个
  ```

- 多个匹配

  用；隔开

  ``` shell
  sed '1,3s/my/your/g; 3,$s/This/That/g' my.txt
  ```

- 我们可以使用&来当做被匹配的变量，然后可以在基本左右加点东西。如下所示

  ```shell
  sed "s/my/[&]/g" my
  [my]-[my]-[my]-[my]
  ```

- 圆括号匹配

  圆括号括起来的正则表达式所匹配的字符串会可以当成变量来使用，sed中使用的是\1,\2…

  ```shell
  my-my-my-my
  sed "s/\(my\)/\1hello/g" my
  myhello-myhello-myhello-myhello
  ```

### N命令

​	N命令 —— 把下一行的内容纳入当成缓冲区做匹配

```she
sed "N;s/my/you/" my.txt
you-my-my-my
my-my-my-my
you-my-my-my
my-my-my-my
you-my-my-my
my-my-my-my
```

