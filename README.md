## A set of useful custom controls & extensions for iOS using Swift

### AsyncTask

Allows to make async any long-running function in a another thread with completion hanlder in the main loop. Almost like the `Promise` but much easier and without ability of failure

### DI Container

A lightweight replacement of `Swinject` dependency injection framework, that doesn't requires framework recompilation after each Xcode update

### Material TextField

An example of implementation of `UITextField`-based custom control with the floating placeholder and bottom line
![](http://bingosoft.info/images/MaterialTextField.gif)

### Observable

An implementation of the *Observable* design pattern in Swift. Don't hold strong reference to the observer. Automatically cleans the observers list after the observer has been deallocated, don't send events to dead objects, like `NotificationCenter` does throwing an exception `CFNOTIFICATIONCENTER_IS_CALLING_OUT_TO_AN_OBSERVER`

### URLImageView

A yet another `UIImageView` that can load images by URL. A good replacement to `SDWebImageView`, supports placeholders while loading image, stores in `NSCache`, persist downloaded images on filesystem, and creates only one network request for multiple images with the same URL
