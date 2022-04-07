Pod::Spec.new do |spec|
spec.name             = "Apptics"
spec.version          = "1.0.4"
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
What's new:

- Added RTL support for all our screens, enhanced tracking session and sending data to the server.

  DESC
  
spec.homepage         = "https://github.com/zoho/Apptics"
spec.author           = { "Saravanan Selvam" => "ssaravanan@zohocorp.com", "Prakash Redrouthu" => "prakash.redrouthu@zohocorp.com" }
spec.source = { :git => 'https://github.com/zoho/Apptics.git', :tag => spec.version }

spec.social_media_url = "http://zoho.com"
spec.documentation_url = "https://prezoho.zohocorp.com/apptics/resources/SDK/iOS/integration.html"

spec.ios.deployment_target = '9.1'
spec.tvos.deployment_target = '9.0'
spec.osx.deployment_target =  '10.10'
spec.watchos.deployment_target = '2.0'

spec.default_subspecs = 'Analytics'

spec.requires_arc = true

spec.subspec 'Analytics' do |an|
an.dependency 'Apptics/Core'
an.dependency 'Apptics/EventTracker'
an.dependency 'Apptics/ScreenTracker'
an.dependency 'Apptics/CrashKit'
an.dependency 'Apptics/Scripts'
end

spec.subspec 'Core' do |co|
co.vendored_frameworks = 'Apptics.xcframework'
end

spec.subspec 'EventTracker' do |et|
et.vendored_frameworks = 'AppticsEventTracker.xcframework'
end

spec.subspec 'ScreenTracker' do |st|
st.vendored_frameworks = 'AppticsScreenTracker.xcframework'
end

spec.subspec 'CrashKit' do |ck|
ck.vendored_frameworks = 'AppticsCrashKit.xcframework'
end

spec.subspec 'Scripts' do |sc|
sc.source_files = 'scripts/*'
sc.preserve_paths = 'scripts/*'
end

end
