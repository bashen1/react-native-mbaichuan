
Pod::Spec.new do |s|
  s.name         = "RNReactNativeMbaichuan"
  s.version      = "1.0.0"
  s.summary      = "RNReactNativeMbaichuan"
  s.description  = <<-DESC
                  RNReactNativeMbaichuan
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNReactNativeMbaichuan.git", :tag => "master" }
  s.source_files  = "RNReactNativeMbaichuan/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  