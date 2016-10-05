#
# Be sure to run `pod lib lint ANWExpandScrollView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ANWExpandScrollView'
  s.version          = '1.0.0'
  s.summary          = 'Expand - Collapse Scroll View - Animate With Pinch Gesture ANWExpandScrollView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Expand - Collapse Scroll View - Animate With Pinch Gesture
                       DESC

  s.homepage         = 'https://github.com/orucanil/ANWExpandScrollView'
  # s.screenshots     = 'http://g.recordit.co/2ExfUA6pbw.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anil Oruc' => 'anil.oruc@hotmail.com' }
  s.source           = { :git => 'https://github.com/orucanil/ANWExpandScrollView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://www.linkedin.com/in/annul'

  s.ios.deployment_target = '7.0'

  s.source_files = 'ANWExpandScrollView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ANWExpandScrollView' => ['ANWExpandScrollView/Assets/*.png', 'ANWExpandScrollView/Assets/*.xib']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
end
