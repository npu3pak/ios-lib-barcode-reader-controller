# BarcodeReaderController

[![CI Status](http://img.shields.io/travis/npu3pak/BarcodeReaderController.svg?style=flat)](https://travis-ci.org/npu3pak/BarcodeReaderController)
[![Version](https://img.shields.io/cocoapods/v/BarcodeReaderController.svg?style=flat)](http://cocoapods.org/pods/BarcodeReaderController)
[![License](https://img.shields.io/cocoapods/l/BarcodeReaderController.svg?style=flat)](http://cocoapods.org/pods/BarcodeReaderController)
[![Platform](https://img.shields.io/cocoapods/p/BarcodeReaderController.svg?style=flat)](http://cocoapods.org/pods/BarcodeReaderController)

## Usage

### Add camera usage description into info.plist
```xml
	<key>NSCameraUsageDescription</key>
	<string>Camera access is required by barcode scanner</string>
```
### Create subclass of BarcodeReaderController

Scanning will stop after barcode detection. If you need to start again call restartScan()

```swift
import UIKit
import BarcodeReaderController

class ViewController: BarcodeReaderController, BarcodeReaderControllerDelegate {
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func onBarcodeDetected(_ value: String, format: BarcodeFormat) {
        let alert = UIAlertController(title: "\(format)", message: value, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "retry", style: .default, handler: {_ in self.restartScan()}))
        present(alert, animated: true, completion: nil)
    }
    
    func onBarcodeReaderInitializationSuccess() {
        errorLabel.isHidden = true
    }
    
    func onBarcodeReaderInitializationFailed() {
        errorLabel.isHidden = false
    }
}
```


## Requirements

## Installation

BarcodeReaderController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BarcodeReaderController", :git => 'https://github.com/npu3pak/ios-lib-barcode-reader-controller.git'
```

## Author

npu3pak, evsafronov.developer@yandex.ru

## License

BarcodeReaderController is available under the MIT license. See the LICENSE file for more info.
