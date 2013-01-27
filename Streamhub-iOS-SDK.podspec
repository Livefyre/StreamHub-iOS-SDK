Pod::Spec.new do |s|
  s.name     = 'Streamhub-iOS-SDK'
  s.version  = '0.2.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = "A client library for Livefyre's API"
  s.homepage = 'https://github.com/Livefyre/StreamHub-iOS-SDK'
  s.authors = {"Livefyre" => "livefyre@livefyre.com"}

  s.source   = { :git => 'https://github.com/Livefyre/StreamHub-iOS-SDK.git', :tag => "0.1" }

  s.platform = :ios, '5.0'

  s.source_files = 'LFClient/'

  s.prefix_header_contents = <<-EOS
    #ifdef __OBJC__
        #import <Foundation/Foundation.h>
        #import "LFConstants.h"
        #import "LFClientBase.h"
    #endif
  EOS

  s.frameworks = 'Foundation'

  s.requires_arc = true
end