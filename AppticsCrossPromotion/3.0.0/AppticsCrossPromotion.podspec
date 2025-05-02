Pod::Spec.new do |spec|
spec.name             = "AppticsCrossPromotion"
spec.version          = "3.0.0"
spec.summary          = "Apptics Remote Config for iOS"
spec.license          = { :type => "MIT", :text=> <<-LICENSE
MIT License
Copyright (c) 2020 Zoho Corporation
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
spec.author = { 'Apptics' => 'apptics-support@zohocorp.com' }
spec.source = { :http => "https://github.com/zoho/Apptics/releases/download/#{spec.version}/AppticsSwiftFiles.zip" }
# spec.source = { :git => "https://github.com/zoho/Apptics.git", :tag=>"#{spec.version}"}
spec.swift_version = '5.0'
spec.ios.deployment_target = '9.1'

spec.default_subspecs = 'CrossPromotion'

spec.requires_arc = true

spec.subspec 'CrossPromotion' do |cp|
      cp.source_files        = 'SwiftFiles/CrossPromoApps/*.swift'
    cp.dependency 'AppticsAnalytics/Apptics', "#{spec.version}"
    cp.resource_bundles = {'Apptics_SwiftResources' => ["SwiftFiles/CrossPromoApps/Fonts/*.{ttf}", "SwiftFiles/CrossPromoApps/ios-xibs/*.{xib}", "SwiftFiles/CrossPromoApps/StringFiles/*.{lproj}","SwiftFiles/CrossPromoApps/*.{xcprivacy}"]}
    cp.platform     = :ios, 9.1

  end

end
