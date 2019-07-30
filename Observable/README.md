# Observable

Implementation of *Observable* design pattern in Swift. Don't holds strong reference on observer. Automatically cleans observers list after observer has been deallocated, don't sends events to dead objects
## How to use:
```swift
class MyObject {
	let changesDidCompleted = Observable<String>()
	
	func performChanges(with param: String) {
		// very important changes
		changesDidCompleted.notify(param)
	}
}

class Observer {
	var holder: ClosureHolder!

	func subscribe(on obj: MyObject) {
		holder = obj.changesDidCompleted += { [weak self] param in
			self?.handler(param)
		}
	}

	func unsubscribe() {
		holder = nil
	}

	func handler(_ name: String) {
		print("handle event \(name)")
	}
}

var obj = MyObject()
var observer: Observer! = Observer()

observer.subscribe(on: obj)
obj.performChanges(with:"Test 1")

observer.unsubscribe()
obj.performChanges(with:"Test 2") // no output

observer.subscribe(on: obj)
obj.performChanges(with:"Test 3")

observer = nil
obj.performChanges(with: "Test 4") // no output
```
Also, you can pass multiple params using a typle as the template parameter
