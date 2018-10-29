---
title: Golang面试总结
date: 2018-06-07 14:30:04
categories: Golang
tags:
	- Golang
	
---

### GO计时器

### Golang中超时处理 （select）

### 协程交替打印1-20

### 协程生产者消费者

* 无缓冲区

  ```go
  func produce(ch chan<- int) {  
      for i := 0; i < 10; i++ {  
          ch <- i  
          fmt.Println("Send:", i)  
      }  
  }  
  func consumer(ch <-chan int) {  
      for i := 0; i < 10; i++ {  
          v := <-ch  
          fmt.Println("Receive:", v)  
      }  
  }  
  // 因为channel没有缓冲区，所以当生产者给channel赋值后，  
  // 生产者线程会阻塞，直到消费者线程将数据从channel中取出  
  // 消费者第一次将数据取出后，进行下一次循环时，消费者的线程  
  // 也会阻塞，因为生产者还没有将数据存入，这时程序会去执行  
  // 生产者的线程。程序就这样在消费者和生产者两个线程间不断切换，直到循环结束。  
  func main() {  
      ch := make(chan int)  
      go produce(ch)  
      go consumer(ch)  
      time.Sleep(1 * time.Second)  
  }  
  ```

  * 有缓存区

  ```go
  func produce(ch chan<- int) {  
      for i := 0; i < 10; i++ {  
          ch <- i  
          fmt.Println("Send:", i)  
      }  
  }  
  func consumer(ch <-chan int) {  
      for i := 0; i < 10; i++ {  
          v := <-ch  
          fmt.Println("Receive:", v)  
      }  
  }  
  func main() {  
      ch := make(chan int, 10)  
      go produce(ch)  
      go consumer(ch)  
      time.Sleep(1 * time.Second)  
  }  
  ```

  

### go变量默认

### go slice实现

​	slice的数据结构定义如下

```go
type slice struct {  
    array unsafe.Pointer
    len   int
    cap   int
}
```





### Go单例模式

```go
//Singleton 是单例模式类
type Singleton struct{}

var singleton *Singleton
var once sync.Once

//GetInstance 用于获取单例模式对象
func GetInstance() *Singleton {
	//Once have a method  Do(f func())
	//Do judge by done's value  whether it should perform the f method
	once.Do(func() {
		singleton = &Singleton{}
	}
	return singleton
}
```

