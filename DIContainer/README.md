# DI Container

A lightweight replacement of [Swinject](https://github.com/Swinject/Swinject) dependency injection framework, that doesn&apos;t requires framework recompilation after each Xcode update. It was very annoying to get every time the error about Swift incompatible swiftmodule versions like

> Module compiled with Swift 4.2 cannot be imported by the Swift 5.0 compiler

This error often wasted my time, so I decided to use native solution,  that doesn't required recompilation of framework. It&apos;s quite simple to determine the proper object to given protocol, so why not using own DI container

## Features

- Support the same interface like `Swinject`, so you don't need to rewrite an existing `Swinject` based DI Container
- Support `transient` aka temporary and `container` aka singleton object scopes
- Don't require each time recompilation for module compatibility

## Usage example

It&apos;s still mostly the same like in [Swinject](https://github.com/Swinject/Swinject), except advanced rarely used features
