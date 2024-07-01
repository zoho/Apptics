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
  spec.version          = "2.0.7002"
  spec.summary          = "An in-app usage tracking and analytics library for iOS app extensions"
  spec.license          = { :type => "MIT", :text=> <<-LICENSE
  MIT License
  Copyright (c) 2018 Zoho Corporation Pvt. Ltd
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE
  LICENSE
}

spec.description = <<-DESC

Apptics is a library that enables your app to send in-app usage reports and data securly to our servers. You can track Sessions, Screens, and we also offer Crash Reporting. With minimal initialization of the framework, you get these features without doing any other configuration.

DESC
  spec.homepage         = "https://github.com/zoho/Apptics"
  spec.author           = {"Saravanan S" => "ssaravanan@zohocorp.com", "Prakash Red" => "prakash.redrouthu@zohocorp.com","Jaikarthick" => "jaikarthick.jk@zohocorp.com"}
  spec.social_media_url = 'https://twitter.com/zoho'
  spec.source = { :http => "https://github.com/zoho/Apptics/releases/download/#{spec.version}/AppticsSwiftFiles.zip" }
  # spec.source = { :git => "https://github.com/zoho/Apptics.git", :tag=>"#{spec.version}"}
    spec.requires_arc = true
  spec.swift_version = '5.0'
  

    spec.ios.deployment_target = '9.1'
    spec.tvos.deployment_target = '9.0'
    spec.osx.deployment_target =  '10.10'
    spec.watchos.deployment_target = '2.0'

    spec.default_subspecs = 'Extension'

  spec.subspec 'Extension' do |ex|
      ex.source_files        = 'SwiftFiles/AppExtension/*.swift'
      ex.ios.deployment_target = '9.1'
      ex.resources  = 'SwiftFiles/AppExtension/*.{xcprivacy}'
  end
end

