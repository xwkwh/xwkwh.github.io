---
title: Linux常用命令
date: 2018-06-21 21:10:26
categories: 计算机
tags:
	- 计算机
	- Linux
---

## Linux常用命令

### 一、文件目录

1. ls 查看目录文件

2. cd 改变路径

3. pwd  显示当前路径

4. mkdir  新建路径

5. rm  删除文件

   ```
   -f, –force 		  忽略不存在的文件，从不给出提示。 
   -i, –interactive   进行交互式删除 
   -r, -R, –recursive 指示rm将参数中列出的全部目录和子目录均递归地删除。 
   -v, –verbose       详细显示进行的步骤 
   ```

6. mv  移动文件

7. cp  复制

8. touch  ： 新建空文件

9. cat：打印输出

10. nl：统计输入中的行号，和cat -n类似但有差别

11. more / less ：分页显示内容

12. head/tail ： 显示文件的头和尾内容

    ```
    -n<数字>：指定显示头部内容的行数；
    -c<字符数>：指定显示头部内容的字符数；
    -v：总是显示文件名的头信息；
    -q：不显示文件名的头信息。
    ```

### 二、查找

1. which：在PATH变量指定的路径中，搜索某个系统命令的位置 

2. whereis：用于程序名的搜索， 

3. locate 相当于find -name的缩写  **locate 路径 ** 

4. find: find   path   -optio

5. grep：Global Regular Expression Prin 可以**指定文件中搜索特定的内容，并将含有这些内容的行标准输出** 

   ```
   －c：只输出匹配行的计数。
   －I：不区分大小写（只适用于单字符）。
   －h：查询多文件时不显示文件名。
   －l：查询多文件时只输出包含匹配字符的文件名。
   －n：显示匹配行及行号。
   －s：不显示不存在或无匹配文本的错误信息。
   －v：显示不包含匹配文本的所有行。
   ```

### 三、压缩解压 

1. tar
2. zip

### 四、文件权限

1. chmod

   ```
   r=4,w=2,x=1
   chmod xxx filename
   ```

2. chgrp 更改文件拥有组 

3. chown 更改文件拥有者

   ```
   chown [-R] user dir/file
   chown [-R] user:group dir/file
   ```

### 五、磁盘存储进程

1. top ：性能分析工具，能够实时显示系统中各个进程的资源占用状况 

2. ps：瞬间进程 (process) 的动态

   ```
   ps [options] [--help]
   
   -A：列出所有的进程。 
   -l：显示长列表。 
   -m：显示内存信息。 
   -w：显示加宽可以显示较多的信息。 
   -e：显示所有进程。 
   a：显示终端上的所有进程,包括其它用户的进程。 
   -au：显示较详细的信息。 
   -aux：显示所有包含其它使用者的进程。
   ```

3. free： 显示内存使用

4. pmap :可以根据进程查看进程相关信息占用的内存情况，(进程号可以通过ps查看)如下所示： 

   `pmap -d 14596 `

5. vmstat ：Linux中监控内存的常用工具，可对操作系统的虚拟内存、进程、CPU等的整体情况进行监视. 

6. iostat 通过观察设备的活跃时间和他们平均传输率之间的关系来监视系统的输入/输出 

   ````
   iostat -d -k 1 10         #查看TPS和吞吐量信息(磁盘读写速度单位为KB)
   iostat -d -m 2            #查看TPS和吞吐量信息(磁盘读写速度单位为MB)
   iostat -d -x -k 1 10      #查看设备使用率（%util）、响应时间（await） iostat -c 1 10 #查看cpu状态
   ````

7. lsof

### 六、网络

1. ifconfig  查看设置网卡参数

   ```
   ifconfig eth0 up/down   启用或关闭指定网卡
   ifconfig eth0      显示网卡信息
   ```

2. route 查看路由以及添加路由

   ```
   route -n  显示路由表
   route add/del default gw 192.168.120.1  删除和添加设置默认网关
   route add -net 172.25.0.0 netmask 255.255.0.0 dev eth0 添加网关
   ```

3. ping  测试网络连通性

4. telnet

5. netstat 查看网络状态

   ```
   1 netstat
   2 netstat -nu 只显示udp / -t只显示tcp
   3 netstat -r  显示路由表，作用同route  
   ```

6. traceroute   查看路由轨迹

   ```
   traceroute www.163.com
   traceroute -n www.163.com  显示IP地址，不查主机名
   ```

7. rcp

8. scp

9. ss 查看网络状态

   ```
   ss  -s  我想查看当前服务器的网络连接统计
   ss -l   我想查看所有打开的网络端口
   ss -a   查看这台服务器上所有的socket连接
   ```

10. nslookup，dns查看

    ```
    nslookup  baidu.com
    nslookup -qt=mx 163.com 8.8.8.8
    ```

### 七、其他

1. ln 

   ```
   ln /etc/passwd passwd  创建硬链接
   ln -s 创建软链接
   ```

2. | 管道

3. diff

4. sed： 批处理文本文件

   ```
   grep 更适合单纯的查找或匹配文本
   sed 更适合编辑匹配到的文本
   awk 更适合格式化文本，对文本进行较复杂格式处理
   ```

5. date

6. cal

7. wc 统计

   ```
   wc [-lwm]
   选项：
   -l  ：仅列出行；
   -w  ：仅列出多少字(英文单字)；
   -m  ：多少字符；
   ```

8. watch

9. at 在一个指定的时间执行一个指定任务，只能执行一次，且需要开启atd进程 

   

10. wget