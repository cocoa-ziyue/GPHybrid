#
# Be sure to run `pod lib lint GPHybrid.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GPHybrid'
  s.version          = '0.1.0'
  s.summary          = 'A short description of GPHybrid.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ziyue92/GPHybrid'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ziyue92' => 'ziyue92@qq.com' }
  s.source           = { :git => 'https://github.com/ziyue92/GPHybrid.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'GPHybrid/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GPHybrid' => ['GPHybrid/Assets/*.png']
  # }

s.prefix_header_contents = '
//屏幕适配
#define FitAllScreen(value1, value2) (SCREEN_WIDTH >= 414 ? (Fit6P(value1)) : (Fit6(value2)))
#define Fit6P(value) ((value) / 1242.0f * [UIScreen mainScreen].bounds.size.width)
#define Fit6(value) ((value) / 750.0f * [UIScreen mainScreen].bounds.size.width)
#define FitAllFont(value1, value2) (SCREEN_WIDTH >= 414 ? (value1) : (value2))
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define NavHeight 60

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS8LESS ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0)
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define iOS9LESS ([[UIDevice currentDevice].systemVersion doubleValue] <= 9.0)
#define iOS10MORE ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
#define HWColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]
#define NavBgColor HWColor(23,28,32)

'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Masonry'
   s.dependency 'AFNetworking'
   s.dependency 'GPNavigationController'
   s.dependency 'libextobjc'

end
