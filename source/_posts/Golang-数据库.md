---
title: Golang 数据库
date: 2016-12-07 14:30:04
categories: Golang
tags:
	- Golang

---

## database/sql 接口
Go没有官方提供数据库驱动，而是为开发者开发数据库驱动定义了一些标准接口，开发者可以根据定义的接口来开发相应的数据库驱动
    **好处**：只要按照标准接口开发的代码，以后需要迁移数据库时，不需要任何修改。

### sql.Register
用来注册数据库驱动
第三方数据库驱动开发是，都要实现init函数，在init函数里面会调用

    sql.Register(name string,driver driver.Driver)

完成驱动注册

例如：sqlite3、mymysql的驱动注册

    //https://github.com/mattn/go-sqlite3 驱动
    func init() {
    sql.Register("sqlite3", &SQLiteDriver{})
    }
    //https://github.com/mikespook/mymysql 驱动
    // Driver automatically registered in database/sql
    var d = Driver{proto: "tcp", raddr: "127.0.0.1:3306"}
    func init() {
    Register("SET NAMES utf8")
    sql.Register("mymysql", &d)
    }

在 database/sql 内部通过一个 map 来存储用户定义的相应驱动

    var drivers = make(map[string]driver.Driver)
    
    drivers[name] = driver

因此通过database/sql 的注册函数可以同时注册多个数据库驱动，只要不重复

使用【import _ 包路径】只是引用该包，仅仅是为了调用init()函数，所以无法通过包名来调用包中的其他函数

    import (
    "database/sql"
    _ "github.com/mattn/go-sqlite3"
    )

### driver.Driver
Driver是一个数据库驱动的接口
定义了一个方法： Open(name string) 返回一个数据库的Conn接口

    type Driver interface {
         Open(name string) (Conn, error)
    }

返回的Conn只能执行一次goroutine操作，就是说不能把这个Conn应用于多个goroutine里面

### driver.Conn
Conn 是一个数据库连接的接口定义，定义了一系列方法

    type Conn interface {
        Prepare(query string) (Stmt, error)
        Close() error
        Begin() (Tx, error)
    }

Prepare函数返回与当前连接相关的执行 Sql 语句的准备状态，可以进行查询、删除等操作。

Close 函数关闭当前的连接，执行释放连接拥有的资源等清理工作。因为驱动实现了
database/sql 里面建议的conn pool，所以你不用再去实现缓存 conn 之类的，这样会容易
引起问题。

Begin 函数返回一个代表事务处理的 Tx，通过它你可以进行查询,更新等操作，或者对事务
进行回滚、递交

### driver.Stmt
Stmt是一种准备好的状态，和Conn 相关联，而且只能应用于一个 goroutine 中，不能应
用于多个goroutine

    type Stmt interface {
        Close() error
        NumInput() int
        Exec(args []Value) (Result, error)
        Query(args []Value) (Rows, error)
    }

Close 函数关闭当前的链接状态，但是如果当前正在执行 query，query 还是有效返回 rows
数据。

NumInput 函数返回当前预留参数的个数，当返回>=0时数据库驱动就会智能检查调用者的
参数。当数据库驱动包不知道预留参数的时候，返回-1。

Exec 函数执行Prepare准备好的sql，传入参数执行update/insert 等操作，**返回 Result 数
据**

Query 函数执行Prepare准备好的 sql，传入需要的参数执行 select 操作，**返回 Rows 结果
集**

### driver.Tx
事务处理一般就两个过程，**递交**或者**回滚**。数据库驱动里面也只需要实现这两个函数就可以

    type Tx interface {
        Commit() error
        Rollback() error
    }

Commit 递交一个事务
Rollback 回滚一个事务

数据库事务：对数据库所做的一系列修改，**在修改过程中，暂时不写入数据库，而是缓存起来**，用户在自己的终端可以预览变化，直到全部修改完成，并经过检查确认无误后，**一次性提交并写入数据库**，在提交之前，必要的话所做的修改**都可以取消**。提交之后，就不能撤销，提交成功后其他用户才可以通过查询浏览数据的变化。

### driver.Execer
Conn 可选择实现的一个接口

    type Execer interface {
        Exec(query string, args []Value) (Result, error)
    }

如果这个接口没有定义，那么在调用DB.Exec 就会先调用Prepare 返回Stmt，然后执行Stmt的Exec，然后关闭Stmt

### driver.Result
Update/insert 等操作返回的结果接口定义

    type Result interface {
        LastInsertId() (int64, error)  //返回由数据库执行插入操作得到的自增 ID 号
        RowsAffected() (int64, error)  //返回 query 操作影响的数据条目数
    }

### driver.Rows
执行查询返回的结果接口定义

    type Rows interface {
        Columns() []string
        Close() error
        Next(dest []Value) error
    }

Columns 函数返回查询数据库表的字段信息，这个返回的slice **和 sql 查询的字段**一一对应，
而不是返回整个表的所有字段。

Close 函数用来关闭Rows迭代器。

Next函数用来返回下一条数据，把数据赋值给 dest。dest里面的元素必须是driver.Value的
值除了string，返回的数据里面所有的 string都必须要转换成[]byte。如果最后没数据了，
Next函数最后返回 io.EOF

### driver.RowsAffected

    type RowsAffected int64
    func (RowsAffected) LastInsertId() (int64, error)
    func (v RowsAffected) RowsAffected() (int64, error)

其实就是int64 的别名，但是实现了Result接口，用来底层实现Result的表示方式

### driver.Value
Value其实就是一个**空接口**，他可以容纳**任何的数据**

    type Value interface{}

drive的Value是驱动必须能够操作的Value，Value要么**是 nil，要么是下面的任意一种**

    int64
    float64
    bool
    []byte
    string [*]除了Rows.Next 返回的不能是 string.
    time.Time

### driver.ValueConverter
ValueConverter 接口定义了如何把一个普通的值转化成 driver.Value的接口

    type ValueConverter interface {
         ConvertValue(v interface{}) (Value, error)
    }

在开发的数据库驱动包里面实现这个接口的函数在很多地方会使用到，这个ValueConverter 有很多**好处**：
• 转化driver.value到数据库表相应的字段，例如 int64 的数据如何转化成数据库表uint16字段
• 把数据库查询结果转化成driver.Value值
• 在scan 函数里面如何把 dirve.Value 值转化成用户定义的值

### driver.Valuer
Valuer 接口定义了返回一个 driver.Value 的方式

    type Valuer interface {
        Value() (Value, error)
    }

很多类型都实现了这个Value方法，用来自身与 driver.Value 的转化。
通过上面的讲解，你应该对于驱动的开发有了一个基本的了解，一个驱动只要实现了**这些
接口就能完成增删查改等基本操作了**，剩下的就是与相应的数据库进行数据交互等细节问
题了，在此不再赘述。

### database/sql
database/sql 在database/sql/driver 提供的接口基础上定义了一些更高阶的方法，用以简
化数据库操作,同时内部还建议性地实现一个 conn pool。

    type DB struct {
        driver driver.Driver
        dsn string
        mu sync.Mutex // protects freeConn and closed
        freeConn []driver.Conn
        closed bool
    }

我们可以看到Open 函数返回的是 DB 对象，里面有一个 freeConn，它就是那个简易的连
接池。它的实现相当简单或者说简陋，就是当执行 Db.prepare 的时候会 defer
db.putConn(ci, err) ,也就是把这个连接放入连接池，每次调用 conn 的时候会先判断
freeConn 的长度是否大于0，大于0说明有可以复用的 conn，直接拿出来用就是了，如果
不大于0，则创建一个conn,然后再返回之。





