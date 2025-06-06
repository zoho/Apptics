Pod::Spec.new do |spec|
spec.name             = "AppticsAnalytics"
spec.version          = "1.0.9d"
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
spec.author = { 'Apptics' => 'apptics-support@zohocorp.com' }
spec.source = { :http => "https://github.com/zoho/Apptics/releases/download/#{spec.version}/Apptics.zip"}

spec.social_media_url = "http://zoho.com"
spec.documentation_url = "https://prezoho.zohocorp.com/apptics/resources/SDK/iOS/integration.html"

spec.ios.deployment_target = '9.1'
spec.tvos.deployment_target = '9.0'
spec.osx.deployment_target =  '10.10'
spec.watchos.deployment_target = '2.0'
spec.default_subspecs = 'Core'

spec.requires_arc = true

spec.subspec 'Core' do |an|
an.dependency 'AppticsAnalytics/Apptics'
an.dependency 'AppticsAnalytics/EventTracker'
an.dependency 'AppticsAnalytics/ScreenTracker'
an.dependency 'AppticsAnalytics/CrashKit'
end

spec.subspec 'JWT' do |jwt|
jwt.vendored_frameworks = 'JWT.xcframework'
end

spec.subspec 'Apptics' do |ap|
ap.vendored_frameworks = 'Apptics.xcframework'
ap.dependency 'AppticsAnalytics/JWT'
end

spec.subspec 'EventTracker' do |et|
et.vendored_frameworks = 'AppticsEventTracker.xcframework'
end

spec.subspec 'ScreenTracker' do |st|
st.vendored_frameworks = 'AppticsScreenTracker.xcframework'
end

spec.subspec 'KSCrash' do |ks|
ks.vendored_frameworks = 'KSCrash.xcframework'
end

spec.subspec 'CrashKit' do |ck|
ck.vendored_frameworks = 'AppticsCrashKit.xcframework'
ck.dependency 'AppticsAnalytics/KSCrash'
end

end
