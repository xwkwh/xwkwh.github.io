---
title: Golang Goroutine源码解析 -1
date: 2018-06-21 21:10:26
categories: Golang
tags:
	- Golang
	- goroutine
---

## Golang Goroutine源码解析 -1

### Golang 调度器四个重要结构 ：M P G Sched

MPG的结构源码在src/runtime2.go文件中

1. **M** （Machine）代表着一个内核线程 一个M就是一个内核线程，goroutine就是跑在M之上的
2. **P** 代表着(Processor)处理器 它的主要用途就是用来执行goroutine的，所以它也维护了一个可运行的goroutine队列，和自由的goroutine队列，里面存储了所有需要它来执行的goroutine。
3. **G** 代表着goroutine 实际的数据结构(就是你封装的那个方法)，并维护者goroutine 需要的栈、程序计数器以及它所在的M等信息。
4. **Sched** 代表着一个调度器 它维护有存储空闲的M队列和空闲的P队列，可运行的G队列，自由的G队列以及调度器的一些状态信息等。

**M上有P，P里有G，Sched调度M、P、G**

三者关系图：

![Alt text](https://i6448038.github.io/img/csp/GMPrelation.png "MPG")

一个M会对应一个内核线程，一个M也会连接一个上下文P，一个上下文P相当于一个“处理器”，一个上下文连接一个或者多个Goroutine。P(Processor)的数量是在启动时被设置为环境变量GOMAXPROCS的值，或者通过运行时调用函数`runtime.GOMAXPROCS()`进行设置。 Goroutine中就是我们要执行并发的代码。图中P正在执行的`Goroutine`为蓝色的；处于待执行状态的`Goroutine`为灰色的，灰色的`Goroutine`形成了一个队列`runqueues` 

三者关系的宏观的图为：

![Alt text](https://i6448038.github.io/img/csp/total.png)

参考： https://i6448038.github.io/2017/12/04/golang-concurrency-principle/