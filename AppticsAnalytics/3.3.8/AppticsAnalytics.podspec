Pod::Spec.new do |spec|
spec.name             = "AppticsAnalytics"
spec.version          = "3.3.8"
spec.summary          = "Apptics iOS SDK"
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
spec.source = { :http => "https://github.com/zoho/Apptics/releases/download/#{spec.version}/Apptics.zip"}
# spec.source = { :git => "https://github.com/zoho/Apptics.git", :tag=>"#{spec.version}"}

spec.social_media_url = "http://zoho.com"
spec.documentation_url = "https://prezoho.zohocorp.com/apptics/resources/SDK/iOS/integration.html"

spec.ios.deployment_target = '13.0'
spec.tvos.deployment_target = '9.0'
spec.osx.deployment_target =  '10.13'
spec.watchos.deployment_target = '2.0'

spec.default_subspecs = 'CoreWithMXCrash'

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
