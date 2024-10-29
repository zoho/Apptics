Pod::Spec.new do |spec|
spec.name             = "AppticsAnalytics"
spec.version          = "2.1.3002"
spec.summary          = "Apptics iOS SDK"
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
spec.author           = { "Saravanan Selvam" => "ssaravanan@zohocorp.com", "Prakash Redrouthu" => "prakash.redrouthu@zohocorp.com","Jaikarthick" => "jaikarthick.jk@zohocorp.com" }
spec.source = { :http => "https://github.com/zoho/Apptics/releases/download/#{spec.version}/Apptics.zip"}
# spec.source = { :git => "https://github.com/zoho/Apptics.git", :tag=>"#{spec.version}"}

spec.social_media_url = "http://zoho.com"
spec.documentation_url = "https://prezoho.zohocorp.com/apptics/resources/SDK/iOS/integration.html"

spec.ios.deployment_target = '9.1'
spec.tvos.deployment_target = '9.0'
spec.osx.deployment_target =  '10.10'
spec.watchos.deployment_target = '2.0'
#spec.default_subspecs = 'CoreWithMXCrash'

spec.requires_arc = true

spec.subspec 'CoreWithMXCrash' do |an|
an.dependency 'AppticsAnalytics/Apptics'
an.dependency 'AppticsAnalytics/EventTracker'
an.dependency 'AppticsAnalytics/ScreenTracker'
an.ios.dependency 'AppticsAnalytics/MXCrashKit'
an.osx.dependency 'AppticsAnalytics/CrashKit'
an.tvos.dependency 'AppticsAnalytics/CrashKit'
an.watchos.dependency 'AppticsAnalytics/CrashKit'
end

spec.subspec 'CoreWithKSCrash' do |ak|
ak.dependency 'AppticsAnalytics/Apptics'
ak.dependency 'AppticsAnalytics/EventTracker'
ak.dependency 'AppticsAnalytics/ScreenTracker'
ak.dependency 'AppticsAnalytics/CrashKit'
end

spec.subspec 'JWT' do |jwt|
jwt.vendored_frameworks = 'Apptics/JWT.xcframework'
end

spec.subspec 'Apptics' do |ap|
ap.vendored_frameworks = 'Apptics/Apptics.xcframework'
ap.dependency 'AppticsAnalytics/JWT'
end

spec.subspec 'EventTracker' do |et|
et.vendored_frameworks = 'Apptics/AppticsEventTracker.xcframework'
end

spec.subspec 'ScreenTracker' do |st|
st.vendored_frameworks = 'Apptics/AppticsScreenTracker.xcframework'
end

spec.subspec 'KSCrash' do |ks|
ks.vendored_frameworks = 'Apptics/KSCrash.xcframework'
end

spec.subspec 'CrashKit' do |ck|
ck.vendored_frameworks = 'Apptics/AppticsCrashKit.xcframework'
ck.dependency 'AppticsAnalytics/KSCrash'
end

spec.subspec 'MXCrashKit' do |mx|
mx.platform     = :ios
mx.vendored_frameworks = 'Apptics/AppticsMXCrashKit.xcframework'
end

end
