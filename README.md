# VCSticker

[![support](https://img.shields.io/badge/support-ios%2012.0+-orange.svg)](#)
[![GitHub license](https://img.shields.io/github/license/vincent111000/VCSticker)](https://github.com/vincent111000/VCSticker/blob/master/LICENSE)
[![Cocoapods](https://img.shields.io/cocoapods/v/VCSticker)](https://cocoapods.org/pods/VCSticker)
[![Cocoapods platforms](https://img.shields.io/cocoapods/p/VCSticker)](https://cocoapods.org/pods/VCSticker)

VCSticker is used to add text or image overlay which you can resize and rotate it with single finger.

## Preview
![preview](/preview.gif)

## Installation
### Cocoapods
Add the following line to your Podfile:

```ruby
pod 'VCSticker'
```
Then, run the following command:

```ruby
$ pod install
```

### Manually
Just drag the 'VCSticker' folder into your Xcode project.

## Requirements
- iOS 12.0+
- Swift 5.0

## Usage

VCLabelSticker will change its bounds according to the content text automatically, so you just need to specify its center in your code. 
```Swift
let label = VCLabelSticker(center: self.view.center)
sticker.text = "666"
self.view.addSubview(label)
```
VCImageSticker 
```Swift
let image = VCImageSticker(frame: CGRect(x: 20, y: 40, width: 200, height: 200))
image.imageView.image = UIImage(named: "test")
self.view.addSubview(image)
```
Other variables
```Swift
sticker.textColor   = UIColor.red             // text color
sticker.borderColor = UIColor.red             // border color
sticker.closeBtnEnable  = true                // show close button or not
sticker.resizeBtnEnable = true                // show resize button or not
sticker.restrictionEnable = true              // resticts movements in superview bounds or not
sticker.onBeginEditing = {
    // block when the label is activated
}

sticker.finishEditing()                       // deactivate the label when necessary
```
## Author
* Github: [@Vincent](https://github.com/vincent111000)

VCSticker is being used in my private project ['V马甲'](https://apps.apple.com/cn/app/id1487954197), it's a convenient tool app for developers to create screenshots used in AppStore, have a try and maybe you will like it 😄

## License
VCSticker is available under the MIT license. See the LICENSE file for more info.
