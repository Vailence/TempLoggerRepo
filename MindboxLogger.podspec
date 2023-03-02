Pod::Spec.new do |spec|
  spec.name         = "MindboxLogger"
  spec.version      = "0.0.2"
  spec.summary      = "SDK for integration notifications with"
  spec.description  = "This library allows you to integrate notifications and transfer them to Mindbox Marketing Cloud"
  spec.homepage     = "https://github.com/Vailence/TempLoggerRepo"
  spec.license      = { :type => "CC BY-NC-ND 4.0", :file => "LICENSE" }
  spec.author       = { "Mindbox" => "a-911@bk.ru" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/Vailence/TempLoggerRepo.git", :tag => spec.version }
  spec.source_files  = "MindboxLogger/**/*.{swift}", "SDKVersionProvider/**/*.{swift}"
  spec.exclude_files = "Classes/Exclude"
  spec.resources = ["MindboxLogger/**/*.xcdatamodeld"]
  spec.swift_version = "5"

end
