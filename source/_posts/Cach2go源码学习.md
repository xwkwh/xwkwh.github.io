---
title: Cach2go源码学习
date: 2018-06-24 16:10:26
categories: Golang
tags:
	- Golang
	- 
---

## Cach2go源码学习

最近在磕golang，实战项目还不多，周末闲暇之余找了一个比较简单的开源库研究研究，阅读大牛写的开源代码应该对自己学习很有帮助，还能学一些设计思想。为了防止遗忘，把学到的相关记录了一下
cache2go是一个使用golang实现的并发安全并且包含超时机制的缓存库、缓存方式为表，表中可存储key-value方式的数据，可以学习到锁、goroutie、map的使用
关键的几个文件：

```
cache.go
cachetable.go
cacheitem.go
errors.go
```
#### Cache

cache.go 返回或者创建一个cacheTable

```go
var (
    //俩个全局变量
    //cache 实际的存储cache，key是string，value是*CacheTable
    //mutex 是一个RWMutex，读写锁
	cache = make(map[string]*CacheTable)
	mutex sync.RWMutex
)
// Cache returns the existing cache table with given name or creates a new one
// if the table does not exist yet.
func Cache(table string) *CacheTable {
	mutex.RLock()  //当外部调用的时候，先判断有无table，该操作不涉及写，所以用Rlock
	t, ok := cache[table]
	mutex.RUnlock()
	//存在直接返回table，不存在
    //则进行相应的操作，新建一个table，该操作为了同步，加Lock
	if !ok {
		mutex.Lock()
		t, ok = cache[table]
		// Double check whether the table exists or not.
		if !ok {
			t = &CacheTable{
				name:  table,
				items: make(map[interface{}]*CacheItem),
			}
			cache[table] = t
		}
		mutex.Unlock()
	}

	return t
}
```

#### CacheTable

接下来看看cacheTable.go，包含了相关的表结构体和表操作。CacheTable结构体中我们可以看出缓存项为一个map items，并存在指定得表名中(name)中，cleanupTimer与cleanupInterval控制清理缓存。以及三个回调函数。并提供了增加、删除、查找、遍历、刷新等操作。  
其中比较特殊的就是缓存清理周期。主要代码在expirationCheck函数中实现。代码会遍历所有缓存项，为了保证计时器的准确性每次循环都会更新，生命周期设置为‘0’代表永久有效，找到过期的项删除，然后找到即将要过期项的时间用作cleanupInterval(缓存周期)，即下一次缓存更新的时间，开一个gotoutine在缓存周期到了后清理。

```go
// CacheTable is a table within the cache
type CacheTable struct {
	sync.RWMutex
    
	// The table's name. 缓存表名
	name string
	// All cached items. 缓存项，CacheItem结构体为缓存的具体项
	items map[interface{}]*CacheItem

	// Timer responsible for triggering cleanup.  
    // 触发缓存清理的定时器
	cleanupTimer *time.Timer
	// Current timer duration.
    // 缓存清理周期
	cleanupInterval time.Duration

	// The logger used for this table.  缓存表的日志
	logger *log.Logger

	// Callback method triggered when trying to load a non-existing key.
    // 获取一个不存在的缓存项时的回调函数
	loadData func(key interface{}, args ...interface{}) *CacheItem
	// Callback method triggered when adding a new item to the cache.
    // 向缓存表增加缓存项时的回调函数
	addedItem func(item *CacheItem)
	// Callback method triggered before deleting an item from the cache.
    // 从缓存表删除一个缓存项时的回调函数
	aboutToDeleteItem func(item *CacheItem)
}
// Count returns how many items are currently stored in the cache.
// 缓存表中缓存数量
func (table *CacheTable) Count() int {
	table.RLock()   //只需要读，加RLock
	defer table.RUnlock()
	return len(table.items)  //数量即items的长度
}

// Foreach all items 遍历所有缓存项
func (table *CacheTable) Foreach(trans func(key interface{}, item *CacheItem)) {
	table.RLock()    // 加读锁
	defer table.RUnlock()

	for k, v := range table.items {
		trans(k, v) //遍历相关的操作
	}
}

// SetDataLoader configures a data-loader callback, which will be called when
// trying to access a non-existing key. The key and 0...n additional arguments
// are passed to the callback function.
// SetDataLoader配置一个数据加载的回调，当尝试去请求一个不存在的key的时候调用
func (table *CacheTable) SetDataLoader(f func(interface{}, ...interface{}) *CacheItem) {
	table.Lock()
	defer table.Unlock()
	table.loadData = f
}

// SetAddedItemCallback configures a callback, which will be called every time
// a new item is added to the cache.
// SetAddedItemCallback配置一个回调，当向缓存中添加项目时每次都会被调用
func (table *CacheTable) SetAddedItemCallback(f func(*CacheItem)) {
	table.Lock()
	defer table.Unlock()
	table.addedItem = f
}

// SetAboutToDeleteItemCallback configures a callback, which will be called
// every time an item is about to be removed from the cache.
// setabouttodeleteitemcallback配置一个回调，当一个项目从缓存中删除时每次都会被调用
func (table *CacheTable) SetAboutToDeleteItemCallback(f func(*CacheItem)) {
	table.Lock()
	defer table.Unlock()
	table.aboutToDeleteItem = f
}

// SetLogger sets the logger to be used by this cache table.
// 设置缓存表需要使用的log
func (table *CacheTable) SetLogger(logger *log.Logger) {
	table.Lock()
	defer table.Unlock()
	table.logger = logger
}

// Expiration check loop, triggered by a self-adjusting timer.
// 终结检查，被自调整的时间触发
func (table *CacheTable) expirationCheck() {
	table.Lock()
	if table.cleanupTimer != nil {
		table.cleanupTimer.Stop()
	}
	if table.cleanupInterval > 0 {
		table.log("Expiration check triggered after", table.cleanupInterval, "for table", table.name)
	} else {
		table.log("Expiration check installed for table", table.name)
	}

	// To be more accurate with timers, we would need to update 'now' on every
	// loop iteration. Not sure it's really efficient though.
    // 为了定时器更准确，我们需要在每一个循环中更新‘now’，不确定是否是有效率的。
	now := time.Now()
	smallestDuration := 0 * time.Second  
    // 设置默认最小值，遍历items找到其中最接近超时的时间设置为下一次的缓存间隔
	for key, item := range table.items {
		// Cache values so we don't keep blocking the mutex.
		item.RLock()
		lifeSpan := item.lifeSpan
		accessedOn := item.accessedOn
		item.RUnlock()

		if lifeSpan == 0 {  //可以看出，lifespan为0可以永久有效
			continue
		}
		if now.Sub(accessedOn) >= lifeSpan { 
			// Item has excessed its lifespan.
			table.deleteInternal(key) //到期的删除
		} else {
			// Find the item chronologically closest to its end-of-lifespan.
			if smallestDuration == 0 || lifeSpan-now.Sub(accessedOn) < smallestDuration {
				smallestDuration = lifeSpan - now.Sub(accessedOn)
			}//更新smallestDuration使其为items中最小的即将过期的时间，这样方便及时清理
		}
	}

	// Setup the interval for the next cleanup run.
    // 把最小时间赋值给cleanupInterval
	table.cleanupInterval = smallestDuration
	if smallestDuration > 0 {
		table.cleanupTimer = time.AfterFunc(smallestDuration, func() {
			go table.expirationCheck() //通过定时器去并行触发自检
		})
	}
	table.Unlock()
}

func (table *CacheTable) addInternal(item *CacheItem) {
	// Careful: do not run this method unless the table-mutex is locked!
	// It will unlock it for the caller before running the callbacks and checks
	table.log("Adding item with key", item.key, "and lifespan of", item.lifeSpan, "to table", table.name)
	table.items[item.key] = item

	// Cache values so we don't keep blocking the mutex.
	expDur := table.cleanupInterval
	addedItem := table.addedItem
	table.Unlock()

	// Trigger callback after adding an item to cache.
	if addedItem != nil {
		addedItem(item)
	}

	// If we haven't set up any expiration check timer or found a more imminent item.
	if item.lifeSpan > 0 && (expDur == 0 || item.lifeSpan < expDur) {
		table.expirationCheck()
	}
}

// Add adds a key/value pair to the cache.
// Parameter key is the item's cache-key.
// Parameter lifeSpan determines after which time period without an access the item
// will get removed from the cache.
// Parameter data is the item's value.
// 添加键值对到缓存中
// 参数key是cache-key。
// 参数lifeSpan(生命周期)，确定在没有访问该项目的时间段后将从缓存中移除
// 参数data是项目中的值
func (table *CacheTable) Add(key interface{}, lifeSpan time.Duration, data interface{}) *CacheItem {
	item := NewCacheItem(key, lifeSpan, data) // 构造一个item

	// Add item to cache.
	table.Lock()
	table.addInternal(item) // 添加进去，在这个函数中解锁

	return item
}

func (table *CacheTable) deleteInternal(key interface{}) (*CacheItem, error) {
	r, ok := table.items[key]
	if !ok {
		return nil, ErrKeyNotFound
	}

	// Cache value so we don't keep blocking the mutex.
	aboutToDeleteItem := table.aboutToDeleteItem
	table.Unlock()

	// Trigger callbacks before deleting an item from cache.
	if aboutToDeleteItem != nil {
		aboutToDeleteItem(r)
	}

	r.RLock()
	defer r.RUnlock()
	if r.aboutToExpire != nil {
		r.aboutToExpire(key)
	}

	table.Lock()
	table.log("Deleting item with key", key, "created on", r.createdOn, "and hit", r.accessCount, "times from table", table.name)
	delete(table.items, key)  //golang自带 map delete函数

	return r, nil
}

// Delete an item from the cache.
func (table *CacheTable) Delete(key interface{}) (*CacheItem, error) {
	table.Lock()
	defer table.Unlock()
    //作者封装重构了下
	return table.deleteInternal(key)
}

// Exists returns whether an item exists in the cache. Unlike the Value method
// Exists neither tries to fetch data via the loadData callback nor does it
// keep the item alive in the cache.
func (table *CacheTable) Exists(key interface{}) bool {
	table.RLock()
	defer table.RUnlock()
	_, ok := table.items[key] //判断key存不存在
	return ok
}

// NotFoundAdd tests whether an item not found in the cache. Unlike the Exists
// method this also adds data if they key could not be found.
func (table *CacheTable) NotFoundAdd(key interface{}, lifeSpan time.Duration, data interface{}) bool {
	table.Lock()

	if _, ok := table.items[key]; ok {
		table.Unlock()
		return false
	}

	item := NewCacheItem(key, lifeSpan, data)
	table.addInternal(item)

	return true
}

// Value returns an item from the cache and marks it to be kept alive. You can
// pass additional arguments to your DataLoader callback function.
func (table *CacheTable) Value(key interface{}, args ...interface{}) (*CacheItem, error) {
	table.RLock()
	r, ok := table.items[key]
	loadData := table.loadData
	table.RUnlock()

	if ok {
		// Update access counter and timestamp.
		r.KeepAlive()
		return r, nil
	}

	// Item doesn't exist in cache. Try and fetch it with a data-loader.
	if loadData != nil {
		item := loadData(key, args...)
		if item != nil {
			table.Add(key, item.lifeSpan, item.data)
			return item, nil
		}

		return nil, ErrKeyNotFoundOrLoadable
	}

	return nil, ErrKeyNotFound
}

// Flush deletes all items from this cache table.
func (table *CacheTable) Flush() {
	table.Lock()
	defer table.Unlock()

	table.log("Flushing table", table.name)

	table.items = make(map[interface{}]*CacheItem)
	table.cleanupInterval = 0
	if table.cleanupTimer != nil {
		table.cleanupTimer.Stop()
	}
}

// CacheItemPair maps key to access counter
type CacheItemPair struct {
	Key         interface{}
	AccessCount int64
}

// CacheItemPairList is a slice of CacheIemPairs that implements sort.
// Interface to sort by AccessCount.
type CacheItemPairList []CacheItemPair

func (p CacheItemPairList) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }
func (p CacheItemPairList) Len() int           { return len(p) }
func (p CacheItemPairList) Less(i, j int) bool { return p[i].AccessCount > p[j].AccessCount }

// MostAccessed returns the most accessed items in this cache table
// 返回缓存表中被访问最多的项目
func (table *CacheTable) MostAccessed(count int64) []*CacheItem {
	table.RLock()
	defer table.RUnlock()

	p := make(CacheItemPairList, len(table.items))
	i := 0
	for k, v := range table.items {
		p[i] = CacheItemPair{k, v.accessCount}
		i++
	}
	sort.Sort(p)
    
	var r []*CacheItem
	c := int64(0)
	for _, v := range p {
		if c >= count {
			break
		}
		item, ok := table.items[v.Key]
		if ok {
			r = append(r, item)
		}
		c++
	}
	return r
}

// Internal logging method for convenience.  为了方便封装的log方法
func (table *CacheTable) log(v ...interface{}) {
	if table.logger == nil {
		return
	}

	table.logger.Println(v)
}

```

#### CacheItem

接下来看**cacheItem.go**文件，该文件是表中的缓存项CacheItem的实现，从结构体中我们可以看到key与data都是interface{}，即可以传任意类型，但是建议key为可比较的类型。
lifeSpan time.Duration 可设置生命周期，以及创建时间，访问次数等记录

**读锁，在不需要改写的变量上，不需要加，在存在改动的地方加**

```go
// CacheItem is an individual cache item
// Parameter data contains the user-set value in the cache. key对应的value
type CacheItem struct {
	sync.RWMutex

	// The item's key.
	key interface{}
	// The item's data.
	data interface{}
	// How long will the item live in the cache when not being accessed/kept alive.
	lifeSpan time.Duration

	// Creation timestamp.
	createdOn time.Time
	// Last access timestamp.
	accessedOn time.Time
	// How often the item was accessed.
	accessCount int64

	// Callback method triggered right before removing the item from the cache
    // 在删除缓存项之前调用的回调函数
	aboutToExpire func(key interface{})
}

// NewCacheItem returns a newly created CacheItem.
// Parameter key is the item's cache-key.
// Parameter lifeSpan determines after which time period without an access the item
// will get removed from the cache.
// Parameter data is the item's value.
// 构造一个新的缓存项实体，相当于构造函数
// 时间用的是当前时间time.Now()
func NewCacheItem(key interface{}, lifeSpan time.Duration, data interface{}) *CacheItem {
	t := time.Now()
	return &CacheItem{
		key:           key,
		lifeSpan:      lifeSpan,
		createdOn:     t,
		accessedOn:    t,
		accessCount:   0,
		aboutToExpire: nil,
		data:          data,
	}
}

// KeepAlive marks an item to be kept for another expireDuration period.
func (item *CacheItem) KeepAlive() {
	item.Lock()
	defer item.Unlock()
	item.accessedOn = time.Now()// 很机智，改变过期时间的方法居然是吧开始时间改成当前的
	item.accessCount++
}

// LifeSpan returns this item's expiration duration.
func (item *CacheItem) LifeSpan() time.Duration {
	// immutable
	return item.lifeSpan
}

// AccessedOn returns when this item was last accessed.
func (item *CacheItem) AccessedOn() time.Time {
	item.RLock()
	defer item.RUnlock()
	return item.accessedOn
}

// CreatedOn returns when this item was added to the cache.
func (item *CacheItem) CreatedOn() time.Time {
	// immutable
	return item.createdOn
}

// AccessCount returns how often this item has been accessed.
func (item *CacheItem) AccessCount() int64 {
	item.RLock()
	defer item.RUnlock()
	return item.accessCount
}

// Key returns the key of this cached item.
func (item *CacheItem) Key() interface{} {
	// immutable
	return item.key
}

// Data returns the value of this cached item.
func (item *CacheItem) Data() interface{} {
	// immutable
	return item.data
}

// SetAboutToExpireCallback configures a callback, which will be called right
// before the item is about to be removed from the cache.
func (item *CacheItem) SetAboutToExpireCallback(f func(interface{})) {
	item.Lock()
	defer item.Unlock()
	item.aboutToExpire = f
}
```

#### Errors

另外作者为了方便，还自己封装了常用的Error，学习到了

```go
var (
	// ErrKeyNotFound gets returned when a specific key couldn't be found
	ErrKeyNotFound = errors.New("Key not found in cache")
	// ErrKeyNotFoundOrLoadable gets returned when a specific key couldn't be
	// found and loading via the data-loader callback also failed
	ErrKeyNotFoundOrLoadable = errors.New("Key not found and could not be loaded into cache")
)
```







