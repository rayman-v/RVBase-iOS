Pod::Spec.new do |s|
  s.name             = "RVBase-iOS"
  s.version          = "1.0.0"
  s.summary          = "Some relay files used on iOS."
  s.description      = <<-DESC
                       Some relay files used on iOS, which implement by swift.
                       DESC
  s.homepage         = "https://github.com/rayman-v/RVBase-iOS"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "吕润佳" => "" }
  s.source           = { :git => "https://github.com/rayman-v/RVBase-iOS.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/NAME'

  s.platform     = :ios, '8.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'RVBase/*'
  # s.resources = 'Assets'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'

end