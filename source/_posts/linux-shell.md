---
title: Linux Shell Learning
date: 2020-01-02 21:10:26
categories: Linux
tags:
	- Linux
---

<a id="org2d80cd5"></a>

# Base


<a id="orgf8f1226"></a>

## chsh change shell


<a id="org0b6ca4c"></a>

### To Know shells installed

```shell
$ cat /etc/shells
# List of acceptable shells for chpass(1).
# Ftpd will not allow users to connect who are not using
# one of these shells.

/bin/bash
/bin/csh
/bin/dash
/bin/ksh
/bin/sh
/bin/tcsh
/bin/zsh
```


<a id="org782e898"></a>

### check current shell

```shell
$ echo $SHELL
/bin/zsh
```


<a id="org87c17c9"></a>

### change shell in all environment

```shell
$ chsh -s /bin/zsh
Changing shell for xwk.
Password for xwk:
chsh: no changes made
```


<a id="org6705c7e"></a>

## export: change environment variable


<a id="org7814e86"></a>

### export output all environment variable

```shell
$ export
CLICOLOR=1
COLORFGBG='7;0'
COLORTERM=truecolor
COMMAND_MODE=unix2003
GOBIN=/Users/xwk/gopath/bin
GOPATH=/Users/xwk/gopath
GOROOT=/usr/local/go
HOME=/Users/xwk
HOMEBREW_BOTTLE_DOMAIN=https://mirrors.cloud.tencent.com/homebrew-bottles
HOMEBREW_NO_AUTO_UPDATE=1
ITERM_PROFILE=Default
ITERM_SESSION_ID=w0t1p0:5212F532-B525-4B5D-BB6E-238806196C29
LANG=zh_CN.UTF-8
LC_ALL=zh_CN.UTF-8
LC_TERMINAL=iTerm2
LC_TERMINAL_VERSION=3.3.7beta1
LESS=-R
LOGNAME=xwk
LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
LaunchInstanceID=3E754314-9261-4388-9A0E-2FC388411C15
OLDPWD=/Users/xwk
PAGER=less
PATH='/Applications/MacVim.app/Contents/bin:/bin:/usr/bin:/usr/local/bin:/Applications/MacVim.app/Contents/bin:/bin:/usr/bin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/VMware Fusion.app/Contents/Public:/usr/local/go/bin:/Users/xwk/gopath/bin:/Users/xwk/.fzf/bin:/Users/xwk/gopath/bin'
PWD=/etc
SECURITYSESSIONID=18778
SHELL=/bin/zsh
SHLVL=2
```


<a id="orgc2ef8c0"></a>

### Difference of env/set/export/declare

1.  shell variabel

    -   envionment variable
    -   custom variable

2.  Difference

    -   env: current user environment variable
    -   export: same as env, but output sort by name
    -   set: all variable in this shell
    -   declare: same as set, but output sort by name

3.  Conclusion

    -   env/export: show environment variable
    -   set/decare: show all variable


<a id="orge5bd0e9"></a>

### set environment variable

```shell
export PATH=$PATH:/bin
```


<a id="org14e1c49"></a>

### Roles of export

set environment variable

```shell
$ guopu=123
$ echo $guopu
123
$ xwk=456
$ echo $xwk
456
$ export guopu
$ dash
$ echo $guopu
123
$ echo $xwk

```


<a id="org383f21b"></a>

## read


<a id="orga409d2d"></a>

### listen from keyboard

```shell
#!/bin/bash
read -p "Please input your name and age:" name age
echo "Welcome !!! $name is $age"
exit 0
```


<a id="orge179e6b"></a>

### read but time limit

```shell
#!/bin/bash
if read -t 3 -p "Please input your name and age within 3s:" name age
then
    echo "Welcome !!! $name is $age"
else
    echo "Sorry too slow!"
fi
exit 0
```


<a id="orga8fa29f"></a>

### password input

```shell
read  -s -p "Plese input passwd: " passwd
echo "you input: $passwd"
exit 0
```


<a id="org01314bb"></a>

### read from file

-   &- close standard output eg: file fd

1.  Solution 1: read -u

    ```shell
    #!/bin/bash
    # assign the file desciptor to file for input fd # 3 is Input file
    exec 3< test.sh
    
    # read  the file using fd # 3
    count=0
    while read -u 3 var
    do
        let count=$count+1
        echo "LIne $count: $var"
    done
    echo "finished"
    echo "LIne num is $count"
    
    # close fd
    exec 3<&-
    
    ```

2.  Solution 2: pipeline |

    ```shell
    count=0
    cat test.sh | while read line
    do
        let count=$count+1
        echo "Line $count: $line"
    done
    exit 0
    
    ```

3.  Solution 3: redirect <

    ```shell
    count=0
    while read line
    do
        let count=$count+1
        echo "Line $count: $line"
    done < test.sh
    echo "count: $count"
    exit 0
    ```


<a id="orgb3ffd96"></a>

### Line break

Do not let backslash (\\) act as an escape character read -r variable


<a id="org1a4d11f"></a>

## expr: calculation


<a id="org2a6f738"></a>

### +-\*/

```shell
#!/bin/bash
expr 10 + 10
expr 20 - 10
expr 30 / 10
# * is the special character
expr 10 \* 3 
expr \( 3 + 3 \) \* 3 + 10
```


<a id="org8102cf9"></a>

### operate string

| 运算   | 表达式                | 意义                       |
|------ |--------------------- |-------------------------- |
| match  | match STRING REGEXP   | STRING中匹配REGEXP的字符串返回匹配的长度 |
| substr | substr STRING POS LEN | 从POS位置截取LEN长度字符串 |
| index  | index STRING SUBSTR   | 查找子字符串的起始位置     |
| length | length STRING         | 字符串的长度               |


<a id="org7009b46"></a>

## tmux: multi windows and session

Terminal MultipleXer


<a id="org5d56712"></a>

### trouble can solve

-   big data transporting while disconnected
-   compiling and runing but over
-   multi windows


<a id="org4a30031"></a>

### Usage

1.  run

    ```shell
    tmux new -s session_name
    ```

2.  create again

    -   Ctr-b
    -   c

3.  switch windows

    -   C-b
    -   number (the window)

4.  quit

    -   C-b d

5.  back

    ```shell
    $ tmux ls
    0: 1 windows (created Sat Feb 29 23:30:39 2020)
    hello: 4 windows (created Sat Feb 29 23:44:30 2020)
    
    $ tmux a -t hello
    ```

6.  other

| type   | operate | comment                            |
| ------ | ------- | ---------------------------------- |
| pane   | %       | split horizon                      |
|        | "       | split vertical                     |
|        | x       | close current                      |
|        | {       | current forward                    |
|        | }       | current backward                   |
|        | ;       | switch pre pane                    |
|        | o       | next pane(also up/down/left/right) |
|        | space   | switch layout                      |
|        | z       | max current;again z recover        |
|        | q       | show all pane number               |
| window | c       | new window                         |
|        | p       | pre window                         |
|        | n       | nex window                         |
|        | w       | window list                        |
|        | &       | close current                      |
|        | ,       | rename window                      |
|        | number  | switch window                      |
|        | f       | search window                      |

    
    ```shell
    tmux new -s foo # 新建名称为 foo 的会话
    tmux ls # 列出所有 tmux 会话
    tmux a # 恢复至上一次的会话
    tmux a -t foo # 恢复名称为 foo 的会话，会话默认名称为数字
    tmux kill-session -t foo # 删除名称为 foo 的会话
    tmux kill-server # 删除所有的会话
    ```


<a id="org7606d0f"></a>

## alias

```shell
# set alias
alias name=value # = before and after don't have space
# show all alias
alias
alias gomodon
# delete alias
unalias vi
unalias -a # delete all 
```


<a id="orgd89e14d"></a>

## history

-   show time export HISTTIMEFORMAT='%F %T'
-   repeat action C-p
-   clear history -c


<a id="org24369c4"></a>

## xargs

execute arguments


<a id="org8205424"></a>

### pipleline

pipleline can use pre input as after input but cann't use it as arguments eg:

```shell
➜  ~ echo test.log | cat
test.log
➜  ~ echo test.log | xargs cat
hello luojilab
```

xargs default see 'enter tab space' as space use 'xargs -0 'can change it as NULL


<a id="org1657276"></a>

### xargs -p :y/n

```shell
~ echo test.log | xargs -p cat
cat test.log ?...y
hello luojilab
```


<a id="org113d414"></a>

### xargs -E quit

```shell
➜  ~ cat test.log
hello he hhh yy
➜  ~ cat test.log| xargs -E "hhh" echo
hello he
```


<a id="orgb2ef30d"></a>

## time


<a id="orgefa19d4"></a>

### time a simple command or give resource usage

```shell
[root@BJ-DEV-GO ledgers]# time grep mockUids ledgers.log

real	0m0.164s
user	0m0.099s
sys	0m0.046s
```


<a id="orgd97a4ee"></a>

## sleep

```shell
$ date;sleep 30s;date
2020年 3月 1日 星期日 16时16分41秒 CST
2020年 3月 1日 星期日 16时17分11秒 CST
```


<a id="orgc9fd929"></a>

# FIle


<a id="org3c69f43"></a>

# Text
