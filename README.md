StreamHub-iOS-SDK
=================

Use this open-source library to integrate Livefyre services into your native iOS app.
This SDK provides an AFNetworking-compatible layer for common API mechanisms.

Also see the sample app project at https://github.com/Livefyre/StreamHub-iOS-Example-App
For information about the Livefyre API, visit https://github.com/Livefyre/livefyre-docs/wiki/StreamHub-API-Reference

# Getting Started

## Cocoa Pods

The easiest way to install StreamHub SDK into your project is to use CocoaPods (if you aren't
using CocoaPods already, you should!). StreamHub SDK does not yet have a spec on CocoaPods.org, 
so you should specify Github repository when adding it to your pods. Here is an example Podfile:

    platform :ios, :deployment_target => '6.0'

    pod 'StreamHub-iOS-SDK', :git => 'https://github.com/Livefyre/StreamHub-iOS-SDK', :commit => 'bec9627553f454ed3538449ac3d53e0b572a292c'

Once your Podfile is placed in your app project root, simply run:

    pod install

This will download all the dependencies and create a file called `MyApp.xcworkspace` which you should
use to open your app project in Xcode in the future.

## Subproject

Alternatively, clone the repository:

    git clone https://github.com/crino/instagram-ios-sdk.git

And then add the Xcode project (LFSClient.xcodeproj) to your app as a subproject (easily done 
by simply dragging the LFSClient.xcodeproj file into Project Navigator pane in Xcode).

# Requirements

At present, StreamHub-SDK v0.2.0 requires iOS 6.0 (mostly due to external dependencies). If you
would like to use this SDK with iOS versions prior to 6.0, please contact Livefyre and we'll 
be happy to help.

# License

Copyright (C) 2013 Livefyre

Distributed under the MIT License.
