//
//  DIContainer.swift
//
//  Created by Andrey Yarosh on 9/24/19.
//  Copyright © https://github.com/bingosoft/. All rights reserved.
//

import Foundation

private protocol OptionalProtocol {
	static var wrappedType: Any.Type { get }
}

extension Optional: OptionalProtocol {
	static var wrappedType: Any.Type { return Wrapped.self }
}

enum ContainerObjectScope {
	case transient
	case container
}

class ContainerObjectScopeRegistrar {
	weak var container: Container?
	var type: Any.Type

	init(_ container: Container, _ type: Any.Type) {
		self.container = container
		self.type = type
	}

	func inObjectScope(_ scope: ContainerObjectScope) {
		container?.register(type: type, in: scope)
	}
}

class Container {
	private var objectScopes = [String: ContainerObjectScope]()
	private var dependencies = [String: () -> Any]()
	private var instances = [String: Any]()
	private let lock = NSRecursiveLock()

	private func getClassName(_ type: Any.Type) -> String {
		if let type = type as? OptionalProtocol.Type {
			return String(describing: type.wrappedType)
		} else {
			return String(describing: type)
		}
	}

	@discardableResult func register(_ type: Any.Type, constructor: @escaping ((Container) -> Any)) -> ContainerObjectScopeRegistrar {
		lock.lock()

		defer {
			lock.unlock()
		}

		dependencies[String(describing: type)] = {
			return constructor(self)
		}

		return ContainerObjectScopeRegistrar(self, type)
	}

	func resolve<T>(_ type: T.Type) -> T? {
		lock.lock()

		defer {
			lock.unlock()
		}

		let className = getClassName(type)

		if let instance = instances[className] {
			return instance as? T
		}

		if let ctor = dependencies[className] {
			let obj = ctor() as? T

			if let scope = objectScopes[className], scope == .container {
				instances[className] = obj
			}

			return obj
		}

		return nil
	}

	func register(type: Any.Type, in objectScope: ContainerObjectScope) {
		lock.lock()
		let className = getClassName(type)
		objectScopes[className] = objectScope
		lock.unlock()
	}
}
