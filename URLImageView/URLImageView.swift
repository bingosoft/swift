//
//  URLImageView.swift
//
//  Created by Andrey Yarosh on 3/22/19.
//  Copyright © 2019 https://github.com/bingosoft/swift/
//

import Foundation
import UIKit

protocol URLImageViewInput {
	var url: String! { get set }
	var placeholder: UIImage! { get set }
}

class URLImageView: UIImageView, URLImageViewInput {
	var url: String! {
		didSet {
			image = placeholder

			if let url = url {
				load(from: url)
			}
		}
	}

	var placeholder: UIImage!

	private lazy var cacheDir: String = {
		return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
	}()
	private static let imageCache = NSCache<NSString, UIImage>()
	private static var tasks = Dictionary<URL, DispatchSemaphore>()
	private static var queue = DispatchQueue(label: "URLImageView", attributes: .concurrent)

	private func load(from url: String) {
		guard let url = URL(string: url) else { return }

		let fileName: NSString = "\(url.host!)_\(url.path.replacingOccurrences(of: "/", with: "_"))" as NSString
		let fullPath = URL(fileURLWithPath: "\(self.cacheDir)/\(fileName)")

		if let image = URLImageView.imageCache.object(forKey: fileName) {
			self.image = image
			return
		}

		DispatchQueue.global().async {
			if let semaphore = URLImageView.tasks[url] {
				semaphore.wait()

				if let image = URLImageView.imageCache.object(forKey: fileName) {
					self.reload(image: image, for: url)
				}

				semaphore.signal()
				return
			}

			URLImageView.queue.async(flags: .barrier) {
				URLImageView.tasks[url] = DispatchSemaphore(value: 0)
			}

			let image = self.readLocal(fullPath) ?? self.readRemote(url, fullPath)

			if let image = image {
				URLImageView.imageCache.setObject(image, forKey: fileName)
				self.reload(image: image, for: url)
			}

			URLImageView.queue.async(flags: .barrier) {
				let semaphore = URLImageView.tasks[url]
				URLImageView.tasks[url] = nil
				semaphore?.signal()
			}
		}
	}

	private func reload(image: UIImage, for url: URL) {
		DispatchQueue.main.async {
			if let currentUrl = self.url, url == URL(string: currentUrl) { // check actual url
				UIView.transition(with: self,
								  duration: 0.3,
								  options: .transitionCrossDissolve,
								  animations: {
					self.image = image
				}, completion: nil)
			}
		}
	}

	private func readLocal(_ path: URL) -> UIImage? {
		guard let data = try? Data(contentsOf: path) else { return nil }
		guard let image = UIImage(data: data) else {
			try? FileManager.default.removeItem(at: path) // broken image saved
			return nil
		}

		return image
	}

	private func readRemote(_ url: URL, _ path: URL) -> UIImage? {
		guard let data = try? Data(contentsOf: url) else { return nil }
		guard let image = UIImage(data: data) else { return nil }

		do {
			try data.write(to: path)
		} catch {
			try? FileManager.default.removeItem(at: path) // broken image saved, low space
		}

		return image
	}
}
