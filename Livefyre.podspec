Pod::Spec.new do |s|
  s.name     = 'Streamhub-iOS-SDk'
  s.version  = '0.2.0'
  s.license  = 'MIT'
  s.summary  = "A client library for Livefyre's API"
  s.homepage = 'https://github.com/Livefyre/StreamHub-iOS-SDK'

  s.source   = { :git => 'https://github.com/Livefyre/StreamHub-iOS-SDK' }

  s.platform = :ios

  s.source_files = 'LFClient/LFClient'

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