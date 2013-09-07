Pod::Spec.new do |s|
  s.name         = "StreamHub-iOS-SDK"
  s.version      = "0.2.0-RC1"
  s.summary      = "A client library for Livefyre's API"
  s.description  = <<-DESC
The StreamHub-iOS-SDK is a framework for building native iOS apps that interact with Livefyre services.
It lets you create apps that obtain user-generated content through Livefyre, poll for updates, and modify content.
                   DESC
  s.homepage     = "https://github.com/escherba/StreamHub-iOS-SDK"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { "JJ Weber" => "jj@livefyre.com", "Eugene Scherba" => "escherba@livefyre.com" }
  s.platform     = :ios
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/escherba/StreamHub-iOS-SDK.git", :tag => "0.2.0" }
  s.resources    = 'LFSClient/Resources/*'
  s.subspec 'arc' do |sp|
    s.ios.prefix_header_file = 'LFSClient/LFSClient-Prefix.pch'
    s.source_files  = 'LFSClient/**/*.{h,m}'
    s.requires_arc = true
    s.dependency 'AFNetworking', '~> 1.3.2'
    s.dependency 'JWT', '~> 1.0.3'
    s.dependency 'Base64', '~> 1.0.1'
    s.dependency 'NSString-Hashes', '~> 1.2.0'
  end
  s.subspec 'no-arc' do |sp|
    sp.source_files = 'JSONKit/**/*.{h,m}'
    sp.requires_arc = false
  end
end
