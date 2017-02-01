StreamHub-iOS-SDK FOR SWIFT INTEGRATION
========================================

Use this open-source library to integrate Livefyre services into your native swift app.  This SDK provides a thin layer for common API mechanisms and endpoints on top of the excellent AFNetworking stack.

## Integrating the SDK into your swift project

### As a Cocoa Pod (recommended)

    1. Create the new swift 3 app.
    2. Go to the project through terminal using the command(cd <projectname>).

The most convenient way to add StreamHub-iOS SDK to your project is to use CocoaPods.

    1. Create the pod file. (in terminal in the newly created directory) 

If you don't have CocoaPods, run `gem install cocoapods` and `pod setup`.
            a. pod init

Here is an example Podfile:

```ruby
source 'https://github.com/Livefyre/cocoapods.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, :deployment_target => '8.0'

pod 'StreamHub-iOS-SDK', '~> 0.3.0'
```

Then simply:

pod install

This will download all the dependencies and create a file `MyApp.xcworkspace`, which you should use from now on to open your app project in Xcode. Note running `pod install` will clone `Livefyre/cocoapods.git` repo to `~/.cocoapods/repos/livefyre` directory.

## Get SDK Methods into swift app
```ruby
    Create Bridging-Header file for importing objective-c files.
    import the framework into Swift Brdging file. The naming convention has changed to use _(underscore) instead of -(dash)  
        Example: (#import<StreamHub_iOS_SDK/LFSClient.h>)
    import the StreamHub_iOS_SDK module in which to use the SDK code.
        Example: import StreamHub_iOS_SDK    
```

## Requirements

StreamHub iOS SDK versions since v0.2.0 require iOS 6.0 or higher.

## Appendix (JSON support)

For those looking at StreamHub-iOS SDK internals, please note that we use a modified version of JSONKit [[4]] as the default JSON parser (instead of Apple-provided NSJSONSerialization). We had to do this because the Apple-provided parser does not support decoding JSON files that contain integers or floating point numbers that are larger than those that can be represented by the system. Our modified version of JSONKit truncates very large numbers to corresponding system maximum, instead of throwing an exception.

## License

Copyright (c) 2015 Livefyre, Inc.

Licensed under the MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[1]: https://github.com/Livefyre/StreamHub-iOS-CommentStream-App
[2]: http://answers.livefyre.com/developers/reference/http-reference/
[3]: https://github.com/mattt/AFNetworking
[4]: https://github.com/escherba/JSONKit
[5]: http://stackoverflow.com/a/24651704
[6]: http://livefyre.github.com/StreamHub-iOS-SDK/

