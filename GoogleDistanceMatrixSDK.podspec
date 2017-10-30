Pod::Spec.new do |s|
  s.name             = 'GoogleDistanceMatrixSDK'
  s.version          = '0.1.0'
  s.summary          = 'Unofficial IOS SDK for Google Distance Matrix API.'

  s.homepage         = 'https://github.com/manishkkatoch/GoogleDistanceMatrix-IOS-SDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Manish Katoch' => 'manish.katoch@gmail.com' }
  s.source           = { :git => 'https://github.com/manishkkatoch/GoogleDistanceMatrix-IOS-SDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'Sources/**/*'
end
