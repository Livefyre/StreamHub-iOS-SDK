StreamHub-iOS-SDK
=================

Make iOS apps powered by Livefyre StreamHub

Getting Started
===============

To use the client library you need add the requsite files to your build phase and import them where needed.

You will need all the files in the LFClient directory. You can get them by either checking out this repo or enlisting Cocoa pods to do this for you (soon). You do not need the LFClient project file to use the Livefyre classes in your own project. In fact, the xcode project is mostly there to confuse and mislead you unless you feel the need to hack on LFClient and run the tests.

Using the SDK
=============

The client library exists to make your life easier when talking to the Livefyre backend. It provides a set of clients with helper methods that abstract away the specific endpoints and just return what you want from the server. The docs for these classes live here: http://livefyre.github.com/StreamHub-iOS-SDK/