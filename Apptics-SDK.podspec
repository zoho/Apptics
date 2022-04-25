Pod::Spec.new do |spec|
spec.name             = "Apptics-SDK"
spec.version          = "1.0.5"
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
What's new:

- Handled updating the opt-out status to the Apptics server instantly.
- Enhancements in watchOS tracking. 
- Enhanced sending data to the server on macOS. 

DESC
  
spec.homepage         = "https://github.com/zoho/Apptics"
spec.author           = { "Saravanan Selvam" => "ssaravanan@zohocorp.com", "Prakash Redrouthu" => "prakash.redrouthu@zohocorp.com" }
spec.source = { :http => "https://github.com/zoho/Apptics/releases/download/#{spec.version}/Apptics.zip" }

spec.social_media_url = "http://zoho.com"

spec.ios.deployment_target = '9.1'
spec.tvos.deployment_target = '9.0'
spec.osx.deployment_target =  '10.10'
spec.watchos.deployment_target = '2.0'

spec.default_subspecs = 'Scripts'
spec.dependency 'Apptics', "#{spec.version}"
spec.requires_arc = true


spec.subspec 'Scripts' do |sc|
sc.source_files = 'scripts/*'
sc.preserve_paths = 'scripts/*'
end

end
