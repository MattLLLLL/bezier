<div align="center">
<img src="https://matt-bucket-images.s3-ap-southeast-1.amazonaws.com/bezier/bezier.gif" width="200" height="420"/> <img src="https://matt-bucket-images.s3-ap-southeast-1.amazonaws.com/bezier/bezier_Screen.png" width="200" height="420"/>
</div>

## Requirements 
- iOS 9.0
- Xcode 9
- Swift 4.0

## Installation
You can install MDatePickerView in several ways:

Add source files to your project.
- Use CocoaPods:

```swift
pod 'MDatePickerView'
```

## Usage
```swift
import MDatePickerView
```

## Usage example
```swift
lazy var MDate : MDatePickerView = {
        let mdate = MDatePickerView()
        mdate.Color = .gray
        mdate.delegate = self
        mdate.from = 1980
        mdate.to = 2100
        return mdate
    }()
```

**Adopt the MDatePickerViewDelegate protocol in your view controller, e.g.**
```swift
extension ViewController : MDatePickerViewDelegate {
    func mdatePickerView(selectDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy - MM - dd"
        let date = formatter.string(from: selectDate)
        Label.text = date
    }
}
```

## What's next
- Any suggestions?

## Contribution

- If you found a bug, open an issue
- If you have a feature request, open an issue
- If you want to contribute, submit a pull request
- If you have any issue or want help, please drop me a mail on bowei685@gmail.com

## License

MDatePickerView is distributed under the MIT license. [See LICENSE](https://github.com/MattLLLLL/MDatePickerView/blob/master/LICENSE.md) for details.
