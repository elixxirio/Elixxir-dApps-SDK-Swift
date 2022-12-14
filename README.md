# Elixxir dApps Swift SDK

![Swift 5.7](https://img.shields.io/badge/swift-5.7-orange.svg)
![platform iOS, macOS](https://img.shields.io/badge/platform-iOS,_macOS-blue.svg)

## 📖 Documentation 

- [XXClient Quick Start Guide](Docs/XXClient-quick-start-guide.md)
- [XXMessengerClient](Docs/XXMessengerClient.md)

## 📱 Examples

Check out included [examples](Examples).

## 🛠 Development

Open `Package.swift` in Xcode (≥14).

### Project structure

```
elixxir-dapps-sdk-swift [Swift Package]
 ├─ XXClient [Library]
 └─ XXMessengerClient [Library]
```

### Build schemes

- Use `exlixxir-dapps-sdk-swift-Package` scheme to build and test the package.
- Use other schemes (like `XXClient`) for building and testing individual libraries in isolation.


### Bindings

The package uses `Bindings.xcframework` dependency, built from [go client](https://git.xx.network/elixxir/client) repository. Use `build-bindings.sh` script to update the framework. Information about currently used version is contained in [Frameworks/Bindings.txt](Frameworks/Bindings.txt) file.

## 📄 License

Copyright © 2022 xx network SEZC

[License](LICENSE)
