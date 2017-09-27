# AsyncTask Helper

Allows to make async any long-running function with completion hanlder in the main loop. Almost like a `Promise` but much easier and without ability of failure.

```swift
async {
    print("a heavy task");
}
.then {
    print("make any UI changes after completion");
}
```
## How to wrap a function with return value
```swift
func loadImageAsync(_ url: String) -> AsyncTask<UIImage?>
{
    return AsyncTask<UIImage?> {
        guard let data = try? Data(contentsOf: URL(string: url)!) else { return nil }
        return UIImage(data: data);
    }
}
```
### Method call example
```swift
loadImageAsync(url).then { image in
    imageView.image = image;
}
```

