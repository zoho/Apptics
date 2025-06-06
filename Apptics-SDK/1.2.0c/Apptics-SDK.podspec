Pod::Spec.new do |spec|
spec.name             = "Apptics-SDK"
spec.version          = "1.2.0c"
spec.summary          = "An in-app usage tracking and analytics library for iOS"
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
spec.source = { :http => "https://github.com/zoho/Apptics/releases/download/#{spec.version}/HelperScripts.zip" }
# spec.source = { :git => "https://github.com/zoho/Apptics.git", :tag=>"#{spec.version}"}
spec.social_media_url = "http://zoho.com"

spec.ios.deployment_target = '9.1'
spec.tvos.deployment_target = '9.0'
spec.osx.deployment_target =  '10.10'
spec.watchos.deployment_target = '2.0'

spec.default_subspecs = 'Analytics'

spec.requires_arc = true

spec.subspec 'Analytics' do |an|
an.dependency 'Apptics-SDK/Scripts'
an.dependency 'AppticsAnalytics', "#{spec.version}"
end

spec.subspec 'Scripts' do |sc|
sc.source_files = 'scripts/*'
sc.preserve_paths = 'scripts/*'
end

spec.subspec 'FeedbackKit' do |fbk|
fbk.platform     = :ios, '9.1'
fbk.dependency 'AppticsFeedbackKitSwift', "#{spec.version}"
end

spec.subspec 'ApiTracker' do |at|
at.platforms = {:ios => '9.1', :tvos => '9.0', :osx => '10.10'}
at.dependency 'AppticsApiTracker', "#{spec.version}"
end

spec.subspec 'InAppUpdate' do |au|
au.platform     = :ios, '9.1'
au.dependency 'AppticsInAppUpdate', "#{spec.version}"
end

spec.subspec 'RateUs' do |ru|
ru.platforms = {:ios => '9.1', :tvos => '9.0'}
ru.dependency 'AppticsRateUs', "#{spec.version}"
end

spec.subspec 'RemoteConfig' do |rc|
rc.platforms = {:ios => '9.1', :tvos => '9.0', :osx => '10.10', :watchos => '2.0'}
rc.dependency 'AppticsRemoteConfig', "#{spec.version}"
end

spec.subspec 'Extension' do |ex|
ex.platforms = {:ios => '9.1', :tvos => '9.0', :osx => '10.10', :watchos => '2.0'}
ex.dependency 'AppticsExtension', "#{spec.version}"
end

end
