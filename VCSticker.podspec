#
#  Be sure to run `pod spec lint VCSticker.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name             = 'VCSticker'
  spec.module_name      = 'VCSticker'
  spec.version          = "1.0.4"
  spec.summary          = "Swift 文字、图片便签效果"
  spec.swift_version    = '5.0'
  spec.homepage         = "https://github.com/vincent111000/VCSticker"
  spec.license          = "MIT"
  spec.author           = { "Vincent" => "741955303@qq.com" }
  spec.platform         = :ios, "12.0"
  spec.source           = { :git => "https://github.com/vincent111000/VCSticker.git", :tag => "#{spec.version}" }
  spec.source_files     = "VCSticker/*.{swift}"
  spec.resource_bundles = { 'VCResources' => ['VCSticker/*.xcassets'] }

end
