Pod::Spec.new do |s|
  s.name         = "MarshmallowCore"
  s.version      = "0.0.6"
  s.summary      = "Core memory management and debug components for even the most basic Cocoa application."
  s.description  = "MarshmallowCore contains basic Preference, memory management and debug logging functions. 
                    Features include:
* ARC/Non-ARC memory management model.
* MMLog: a configurable version of NSLog that logs only when you want it to.
* Easy preferences.
* Core Data helper for easier data access.
"
  s.homepage     = "https://github.com/kellyhuberty/MarshmallowCore"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author             = { "Kelly Huberty" => "kellyhuberty@gmail.com" }
  s.social_media_url = "http://twitter.com/kellyhuberty"
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "https://github.com/kellyhuberty/MarshmallowCore.git", :tag => "v0.0.7" }
s.source_files  = 'MarshmallowCore', 'MarshmallowCore/Categories/*.{h,m}', 'MarshmallowCore/Categories/NSString+Marshmallow.h', 'MarshmallowCore/Categories/NSMutableArray+Marshmallow.h', 'Classes/**/*.{h,m}'
  s.framework  = 'Foundation'
  s.requires_arc = true
  s.compiler_flags = '-ObjC'
end
