# ``GradientView``

A simple gradient view for iOS that wraps `CAGradientLayer` in a better API.

## Overview

`CAGradientLayer` is a very powerful tool for displaying gradients in iOS
apps, but it can be difficult to configure correctly, especially for radial
gradients. ``GradientView/GradientView`` attempts to provide a more accessible API for
it, while also wrapping it in a `UIView`, and handling dark and light mode
changes, which `CAGradientLayer` does not do as it uses `CGColor` which
is unaware of interface style changes.

![](Linear) ![](Radial) ![](Conic)

## Topics

### Classes

- ``GradientView/GradientView``
