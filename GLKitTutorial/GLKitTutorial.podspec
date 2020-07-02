#
# Be sure to run `pod lib lint GLKitTutorial.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GLKitTutorial'
  s.version          = '0.0.10'
  s.summary          = 'A short description of GLKitTutorial.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/summerhanada@163.com/GLKitTutorial'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'summerhanada@163.com' => 'qianlongxu@sohu-inc.com' }
  s.source           = { :git => 'https://github.com/summerhanada@163.com/GLKitTutorial.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.resource_bundles = {
    'GLKitTutorial' => ['GLKitTutorial/Assets/**/*.{xib,jpg}']
  }

  s.subspec '0x01' do |sub|
    sub.public_header_files = 'Pod/Classes/0x01/*.h'  
    sub.source_files = 'GLKitTutorial/Classes/0x01/*'
  end
  
  s.subspec '0x02' do |sub|
    sub.public_header_files = 'Pod/Classes/0x02/*.h'  
    sub.source_files = 'GLKitTutorial/Classes/0x02/*'
  end

  s.subspec '0x03' do |sub|
    sub.public_header_files = 'Pod/Classes/0x03/*.h'  
    sub.source_files = 'GLKitTutorial/Classes/0x03/*'
  end

  s.subspec '0x04' do |sub|
    sub.public_header_files = 'Pod/Classes/0x04/*.h'  
    sub.source_files = 'GLKitTutorial/Classes/0x04/*'
  end

  s.subspec '0x05' do |sub|
    sub.public_header_files = 'Pod/Classes/0x05/*.h'  
    sub.source_files = 'GLKitTutorial/Classes/0x05/*'
  end

  s.subspec '0x06' do |sub|
    sub.public_header_files = 'Pod/Classes/0x06/*.h'  
    sub.source_files = 'GLKitTutorial/Classes/0x06/*'
  end

  s.subspec '0x07' do |sub|
    sub.public_header_files = 'Pod/Classes/0x07/*.h'  
    sub.source_files = 'GLKitTutorial/Classes/0x07/*'
  end

  s.subspec '0x08' do |sub|
    sub.public_header_files = 'Pod/Classes/0x08/*.h'  
    sub.source_files = 'GLKitTutorial/Classes/0x08/*'
  end

  s.subspec '0x09' do |sub|
    sub.public_header_files = 'Pod/Classes/0x09/*.h'  
    sub.source_files = 'GLKitTutorial/Classes/0x09/*'
  end

  s.subspec '0x0a' do |sub|
    sub.public_header_files = 'Pod/Classes/0x0a/*.h'  
    sub.source_files = 'GLKitTutorial/Classes/0x0a/*'
  end

  s.frameworks = 'UIKit', 'GLKit'

end
