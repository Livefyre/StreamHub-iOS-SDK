StreamHub-iOS-SDK
=================

Use this open-source library to integrate Livefyre services into your native iOS app.  This SDK provides a thin layer for common API mechanisms and endpoints on top of the excellent AFNetworking stack.

For more information, please see the CommentStream sample app [[1]] or Livefyre HTTP API documentation [[2]].

## Integrating the SDK into your project

### As a Cocoa Pod (recommended)

The most convenient way to add StreamHub-iOS SDK to your project is to use CocoaPods.
If you don't have CocoaPods, run `gem install cocoapods` and `pod setup`.
Here is an example Podfile:

```ruby
source 'https://github.com/Livefyre/cocoapods.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, :deployment_target => '6.0'

pod 'StreamHub-iOS-SDK', :git => 'https://github.com/Livefyre/StreamHub-iOS-SDK.git'

```

Then simply:

    pod install

This will download all the dependencies and create a file `MyApp.xcworkspace`, which you should use from now on to open your app project in Xcode. Note running `pod install` will clone `Livefyre/cocoapods.git` repo to `~/.cocoapods/repos/livefyre` directory.

### As an Xcode subproject

Alternatively, clone the repository:

    git clone https://github.com/Livefyre/StreamHub-iOS-SDK.git

Next, add the Xcode project (LFSClient.xcodeproj) to your app as a subproject (easily done by simply dragging the LFSClient.xcodeproj file into Project Navigator pane in Xcode).

You will also need to do the same with any of the dependencies (AFNetworking [[3]], JSONKit [[4]]).

## Download everything at once (not recommended)

    cd ~/dev
    git clone https://github.com/Livefyre/StreamHub-iOS-SDK.git
    cd StreamHub-iOS-SDK
    git submodule init
    git submodule update
    pod install
    cd examples/CommentStream
    pod install
    open CommentStream.xcworkspace

Note: to run tests in Xcode 6, you will need to add `$(PLATFORM_DIR)/Developer/Library/Frameworks` to `FRAMEWORK_SEARCH_PATHS` in `Pods-test-XCTest+OHHTTPStubSuiteCleanUp` pod [[5]].

You will also need `LFSTestConfig.plist` file from Livefyre which we will provide upon request.

## Xcode Documentation

You can browse the documentation online [[6]] or you can build the "Documentation" target in your Xcode (requires `appledoc` to be installed) on your system.


## Integrating the SDK into swift project

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

pod 'StreamHub-iOS-SDK', :git => 'https://github.com/Livefyre/StreamHub-iOS-SDK.git'
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
[2]: https://answers.livefyre.com/developers/reference/http-reference/
[3]: https://github.com/mattt/AFNetworking
[4]: https://github.com/escherba/JSONKit
[5]: http://stackoverflow.com/a/24651704
[6]: https://livefyre.github.com/StreamHub-iOS-SDK/
