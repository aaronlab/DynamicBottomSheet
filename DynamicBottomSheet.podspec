#
# Be sure to run `pod lib lint DynamicBottomSheet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DynamicBottomSheet'
  s.version          = '1.0.2'
  s.summary          = 'Customizable Dynamic Bottom Sheet Library for iOS'

  s.description      = <<-DESC

Fully Customizable Dynamic Bottom Sheet Library for iOS.
This library doesn't support storyboards.
However, you can easily override variables in DynamicBottomSheetViewController and make the bottom sheet programmatically.

                       DESC

  s.homepage         = 'https://github.com/aaronLab/DynamicBottomSheet'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aaron Lee' => 'aaronlab.net@gmail.com' }
  s.source           = { :git => 'https://github.com/aaronLab/DynamicBottomSheet.git', :tag => s.version.to_s }

  s.requires_arc = true

  s.swift_version = "5.0"
  s.ios.deployment_target = '10.0'

  s.source_files = 'DynamicBottomSheet/Classes/*.{swift}'
  
  s.dependency 'RxSwift', '~> 6.0'
  s.dependency 'RxCocoa', '~> 6.0'
  s.dependency 'RxGesture', '~> 4.0'
  s.dependency 'SnapKit', '~> 5.0'
  s.dependency 'Then', '~> 2.0'
  
end
