# Cuberto's development lab:

Cuberto is a leading digital agency with solid design and development expertise. We build mobile and web products for startups. Drop us a line.

# balloon-picker

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Cuberto/balloon-picker/master/LICENSE)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-green.svg?style=flat)](https://developer.apple.com/swift/)


![Animation](https://raw.githubusercontent.com/Cuberto/balloon-picker/master/Screenshots/animation.gif)

Custom picker view with floating balloon animation

## Requirements

- iOS 10.0+
- Xcode 10

## Installation

Just copy contents of `balloonPicker` folder to your project

## Usage

Instantiate `BalloonPickerView` and add it to your view, or set to custom class of view in storyboard.
Use target-action event `valueChanged` to track value changes.

To customize balloon behavior you can instantiate `BalloonView` and set custom bacground image (see example), inherit your own class from it, or even create your own view conforming to `ProgressTracking` protocol (size of balloon is dermined by `intrinsicContentSize` property, so do not forget to return appropriate value).

Do not set `clipToBounds = true` for picker view.

## Author

Cuberto Design, info@cuberto.com

## License

balloon-picker is available under the MIT license. See the LICENSE file for more info.
