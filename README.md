# A set of useful custom controls & extensions for iOS using Swift

## AsyncTask

Allows to make async any long-running function in a another thread with completion hanlder in the main loop. Almost like a Promise but much easier and without ability of failure

## DI Container

A lightweight replacement of `Swinject` dependency injection framework, that doesn't requires framework recompilation after each Xcode update

## Material TextField

An example of implementation of `UITextField`-based custom control with the floating placeholder and bottom line
![](http://bingosoft.info/images/MaterialTextField.gif)

## Observable

Implementation of *Observable* design pattern in Swift. Don't holds strong reference to observer. Automatically cleans observers list after observer has been deallocated, don't sends events to dead objects, like `NotificationCenter` does throwing an exception __CFNOTIFICATIONCENTER_IS_CALLING_OUT_TO_AN_OBSERVER__

## URLImageView

A yet another `UIImageView` that can load images by URL. A good replacement to `SDWebImageView`, supports `NSCache`, persisting on filesystem, placeholders while loading, and creates only one network request for 1000 images with the same URL
