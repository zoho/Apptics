Pod::Spec.new do |spec|
spec.name             = "AppticsHeatmap"
spec.version          = "3.3.18001"
spec.summary          = "Apptics heatmap interaction capture module for iOS"
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

Optional Apptics addon that captures interaction heatmap telemetry (taps, scrolls, rage/dead clicks) for iOS and Mac Catalyst. Depends on the core Apptics SDK; not included with Apptics by default — add this pod explicitly when needed.

  DESC
  
spec.homepage         = "https://github.com/zoho/Apptics"
spec.author = { 'Apptics' => 'apptics-support@zohocorp.com' }
spec.source = { :http => "https://github.com/zoho/Apptics/releases/download/#{spec.version}/AppticsHeatmap.zip" }

spec.ios.deployment_target = '13.0'
spec.swift_version = '5.0'

spec.default_subspecs = 'AppticsHeatmap'

spec.requires_arc = true

spec.subspec 'AppticsHeatmap' do |hm|
hm.platform     = :ios, '13.0'
hm.vendored_frameworks = 'AppticsHeatmap.xcframework'
hm.ios.dependency 'AppticsAnalytics/Apptics', "#{spec.version}"

hm.frameworks = 'UIKit'
hm.weak_frameworks = 'SwiftUI'
hm.pod_target_xcconfig = { 'SUPPORTS_MACCATALYST' => 'YES' }
hm.source_files        = 'SwiftFiles/AppticsHeatmapWrapper/**/*.swift'
end

end
