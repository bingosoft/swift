//
//  Observable.swift
//
//  Created by Andrey Yarosh on 12/11/18.
//  https://github.com/bingosoft/swift/tree/master/Observable
//  Copyright © 2018 Andrey Yarosh. All rights reserved.
//

import Foundation

class Weak<T: AnyObject> {
	private weak var value: T!

	init(_ value: T) {
		self.value = value
	}

	func get() -> T! {
		return value
	}
}

protocol ClosureHolder { }
typealias ClosureHolders = [ClosureHolder]

class ClosureHolderImpl<Params>: ClosureHolder {
	typealias Callback = (Params) -> Void
	private (set) var call: Callback
	private var parent: Observable<Params>!

	init(_ handler: @escaping Callback, _ observable: Observable<Params>) {
		call = handler
		parent = observable
	}

	deinit {
		parent.clearObsolete()
	}
}

class Observable<Params> {
	private var subscribers = [Weak<ClosureHolderImpl<Params>>]()

	static func += (this: Observable, closure: @escaping (Params) -> Void) -> ClosureHolder {
		let holder = ClosureHolderImpl<Params>(closure, this)
		let weakHolder = Weak<ClosureHolderImpl<Params>>(holder)
		this.subscribers.append(weakHolder)
		return holder
	}

	func clearObsolete() {
		subscribers = subscribers.filter { holder in holder.get() != nil }
	}

	func notify(_ param: Params) {
		subscribers.forEach { weakHolder in
			weakHolder.get()?.call(param)
		}
	}
}

extension Observable where Params == Void {
	func notify() { notify(()) }

	@discardableResult static func += (this: Observable, handler: @escaping () -> Void) -> ClosureHolder {
		let closure = ClosureHolderImpl<Void>(handler, this)
		let weakHolder = Weak<ClosureHolderImpl<Void>>(closure)
		this.subscribers.append(weakHolder)
		return closure
	}
}

class MyObject {
    let myEvent = Observable<String>()
	
	func performChanges(with param: String) {
		myEvent.notify(param)
	}
}

class Observer {
	var holder: ClosureHolder!

	func subscribe(on obj: MyObject) {
		holder = obj.myEvent += { [weak self] param in
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
obj.performChanges(with: "Test 4")  // no output

