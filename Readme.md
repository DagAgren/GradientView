# GradientView #

A simple gradient view for iOS that wraps `CAGradientLayer` in a better API.

## Overview ##

`CAGradientLayer` is a very powerful tool for displaying gradients in iOS
apps, but it can be difficult to configure correctly, especially for radial
gradients. [GradientView](https://dagagren.github.io/GradientView/documentation/gradientview)
attempts to provide a more accessible API for it, while also wrapping it in a
`UIView`, and handling dark and light mode changes, which `CAGradientLayer` does
not do as it uses `CGColor` which is unaware of interface style changes.

<div style="text-align: center">
<img src="https://raw.githubusercontent.com/DagAgren/GradientView/main/GradientView.docc/Resources/Linear.png" width="160">
<img src="https://raw.githubusercontent.com/DagAgren/GradientView/main/GradientView.docc/Resources/Radial.png" width="160">
<img src="https://raw.githubusercontent.com/DagAgren/GradientView/main/GradientView.docc/Resources/Conic.png" width="160">
</div>

## Documentation ##

The code is documented with DocC, and the formatted documentation is available
at <https://dagagren.github.io/GradientView/documentation/gradientview>.

## How to use ##

You can use this repo as a Swift Package Manager package:

`.package(url: "https://github.com/apple/swift-docc-plugin", exact: "1.0.0")`

Or you can simply copy the [GradientView.swift](https://github.com/DagAgren/GradientView/blob/main/GradientView.swift)
file into your project, it is the only file that is needed.

## License ##

This code is released into the public domain with no warranties. If that is not
suitable, it is also available under the
[CC0 license](http://creativecommons.org/publicdomain/zero/1.0/).
