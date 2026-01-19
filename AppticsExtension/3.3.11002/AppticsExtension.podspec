#
# Be sure to run `pod lib lint Apptics_Swift.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|

  spec.name             = "AppticsExtension"
  spec.module_name      = "AppticsExtension"
  spec.version          = "3.3.11002"
  spec.summary          = "An in-app usage tracking and analytics library for iOS app extensions"
  spec.license          = { :type => "Proprietary", :text => <<-LICENSE
Copyright (c) 2025 Zoho Corporation Private Limited
Zoho grants you a limited, revocable, non-exclusive, non-sublicensable license to copy, install and use the Zoho Apptics SDK solely in connection with your use of Zoho Apptics.
You will not:
(i) copy, modify, adapt, translate or otherwise create derivative works of the SDK;
(ii) reverse engineer, decompile, disassemble or otherwise attempt to discover the source code of the SDK;
(iii) rent, sell, assign or otherwise transfer rights in the SDK;
(iv) remove any proprietory notices or licenses from the SDK; or
(v) use, post, publish, transmit or introduce any device, software or routine that interferes or attempts to interfere with the operations SDK.
LICENSE
  }

spec.description = <<-DESC

Apptics is a library that enables your app to send in-app usage reports and data securly to our servers. You can track Sessions, Screens, and we also offer Crash Reporting. With minimal initialization of the framework, you get these features without doing any other configuration.

DESC
  spec.homepage         = "https://github.com/zoho/Apptics"
  spec.author = { 'Apptics' => 'apptics-support@zohocorp.com' }
  spec.social_media_url = 'https://twitter.com/zoho'
  spec.source = { :http => "https://github.com/zoho/Apptics/releases/download/#{spec.version}/AppticsSwiftFiles.zip" }
  # spec.source = { :git => "https://github.com/zoho/Apptics.git", :tag=>"#{spec.version}"}
    spec.requires_arc = true
  spec.swift_version = '5.0'
  

    spec.ios.deployment_target = '13.0'
    spec.tvos.deployment_target = '9.0'
    spec.osx.deployment_target =  '10.13'
    spec.watchos.deployment_target = '4.0'

    spec.default_subspecs = 'Extension'

  spec.subspec 'Extension' do |ex|
      ex.source_files        = 'SwiftFiles/AppExtension/*.swift'
      ex.ios.deployment_target = '9.1'
      ex.watchos.deployment_target = '4.0'
      #ex.resources  = 'SwiftFiles/AppExtension/*.{xcprivacy}'
      ex.resource_bundles = {'AppExtension' => ['SwiftFiles/AppExtension/*.{xcprivacy}'] }

  end
end

