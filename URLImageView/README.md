# URLImageView

A yet another `UIImageView` that can load images using `URL`

### Features

- Async load of images from the given url
- Save already loaded images in `NSCache`.
- Persist already loaded images in app caches directory and restore it back after app relaunch
- Ability to set placeholder while image is loading
- Create only one network request when eventually trying to load 1000 images with the same URL at the same time. Other copies are waiting the result

### How to use
```swift
	let image = URLImageView()
	image.placeholder = UIImage(named: "stub_placeholder")
	image.url = "http://placehold.it/120x120&text=test image"
```
