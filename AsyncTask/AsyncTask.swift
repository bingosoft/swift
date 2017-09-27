//
//  AsyncTask.swift
//
//  Created by Andrey Yarosh on 26/09/2017.
//  Copyright © 2017 https://github.com/bingosoft/ All rights reserved.
//

import Foundation

class AsyncTask<T> {
	private var handler: ((T) -> ())!
	
	func then(_ handler: @escaping (T) -> ()) {
		self.handler = handler;
	}

	init(_ task: @escaping () -> T) {
		DispatchQueue.global(qos: .default).async {
			let result = task();
			
			DispatchQueue.main.async {
				self.handler?(result);
			}
		}
	}
}

func async(_ task: @escaping () -> Void) -> AsyncTask<Void>
{
	return AsyncTask<Void>(task);
}

