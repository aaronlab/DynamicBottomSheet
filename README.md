# DynamicBottomSheet

[![CI Status](https://img.shields.io/travis/aaronLab/DynamicBottomSheet.svg?style=flat)](https://travis-ci.org/aaronLab/DynamicBottomSheet)
[![Version](https://img.shields.io/cocoapods/v/DynamicBottomSheet.svg?style=flat)](https://cocoapods.org/pods/DynamicBottomSheet)
[![License](https://img.shields.io/cocoapods/l/DynamicBottomSheet.svg?style=flat)](https://cocoapods.org/pods/DynamicBottomSheet)
[![Platform](https://img.shields.io/cocoapods/p/DynamicBottomSheet.svg?style=flat)](https://cocoapods.org/pods/DynamicBottomSheet)

Fully Customizable Dynamic Bottom Sheet Library for iOS.

This library doesn't support storyboards.

However, you can easily override variables in DynamicBottomSheetViewController and make the bottom sheet programmatically.

## Preview
[![Preview](./resources/preview.gif)](./resources/preview.gif)

## Requirements

- Swift 5

- iOS 10.0 +

## Installation

DynamicBottomSheet is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DynamicBottomSheet'
```

## Usage

1. Import `DynamicBottomSheet` on top of your view controller file.

2. Create a class for the bottom sheet where its super class is `DynamicBottomSheetViewController`.

3. Put the view you want to show in the `contentView` of the super class `DynamicBottomSheetViewController`.

4. Make `constraints of the view you made` to the `contentView` above.

4. `Present the bottom sheet view controller` you made before in another view controller.

## Example

For more examples, clone the repo, and run `pod install` from the Example directory.

```swift
import UIKit
import DynamicBottomSheet

class MyStackViewBottomSheetViewController: DynamicBottomSheetViewController {
    
    // MARK: - Private Properties
    
    private let stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 32
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
    
}

// MARK: - Layout

extension MyStackViewBottomSheetViewController {
    
    override func configureView() {
        super.configureView()
        layoutStackView()
    }
    
    private func layoutStackView() {
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        Array(1...5).forEach {
            
            let label = UILabel()
            label.text = "\($0)"
            stackView.addArrangedSubview(label)
            
        }
        
    }
    
}
```

```swift
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomSheet = MyStackViewBottomSheetViewController()
        DispatchQueue.main.async {
            self.present(bottomSheet)
        }
    }
}
```

## Customization

```swift
/// The background color of the view controller below the content view.
///
/// - `UIColor.black.withAlphaComponent(0.6)` for others.
open var backgroundColor: UIColor

/// Background view
open var backgroundView: UIView

/// The background color of the content view.
///
/// Default value
/// - `UIColor.tertiarySystemBackground` for iOS 13 or later.
/// - `UIColor.white` for others.
open var contentViewBackgroundColor: UIColor

/// The height of the content view.
///
/// Default value is `nil`
///
/// If you set this value explicitly, the height of the content view will be fixed.
open var height: CGFloat?

/// Content view
open var contentView: UIView

/// Corner radius of the content view(top left, top right)
///
/// Default value is `16.0`
open var contentViewCornerRadius: CGFloat

/// Present / Dismiss transition duration
///
/// Default value is 0.3
open var transitionDuration: CGFloat

/// Dismiss velocity threshold
///
/// Default value is 500
open var dismissVelocityThreshold: CGFloat
```

## Author

Aaron Lee at [Witi](https://www.witi.co.kr/), aaronlab.net@gmail.com

## License

DynamicBottomSheet is available under the MIT license. See the LICENSE file for more info.
