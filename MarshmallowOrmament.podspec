Pod::Spec.new do |s|
  s.name         = "MarshmallowOrmament"
  s.version      = "0.0.2"
  s.summary      = "Basic SQLite ORM."
  s.description  = "ORM For Storing data in SQLite."
  s.homepage     = "https://github.com/kellyhuberty/MarshmallowOrmament"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author             = { "Kelly Huberty" => "kellyhuberty@gmail.com" }
  s.social_media_url = "http://twitter.com/kellyhuberty"
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "https://github.com/kellyhuberty/MarshmallowOrmament.git", :tag => "v0.0.2" }
  s.source_files  = 'MarshmallowOrmament', 'MarshmallowOrmament/Categories/*.{h,m}', 'Classes/**/*.{h,m}'
  s.framework  = 'Foundation'
  s.dependency 'FMDB'
  s.dependency 'couchbase-ios-lite'
end
