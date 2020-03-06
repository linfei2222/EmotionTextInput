Pod::Spec.new do |s|

  s.name         = "EmotionTextInput"
  s.version      = "1.0.1"
  s.summary      = "Emotion and attribute text input for swift"
  s.description  = <<-DESC
  It is a EmotionTextInput used on iOS, which implement by Swift.
                   DESC
  s.homepage     = "https://github.com/linfei2222/EmotionTextInput"
  s.license      = "MIT"
  s.author             = { "linfei2222" => "xingjia90559@163.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/linfei2222/EmotionTextInput.git", :tag => s.version.to_s }
  s.source_files  = "EmotionTextInput/*.swift"
  s.framework  = "UIKit"
  s.module_name = 'EmotionTextInput'

end
