# EmotionTextInput
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/hujewelz/HUPhotoBrowser/master/LICENSE)
[![CocoaPods Compatible](https://img.shields.io/badge/pod-v1.0.1-blue.svg)](https://img.shields.io/badge/pod-v1.0.1-blue.svg)

Emotion and attribute text input for swift

# Example Usage
- **createRichTextView**
```
var richTextView: RichTextView = RichTextView.init(frame: .zero)
richTextView.richDelegate = self
richTextView.backgroundColor = getColorFromHexadecimal(0xF7F7F7)
richTextView.borderColor = getColorFromHexadecimal(0xEAEAEA).cgColor
richTextView.lineFragmentPadding = 15.0
richTextView.font = UIFont.systemFont(ofSize: 14.0)
richTextView.textColor = getColorFromHexadecimal(0x333333)
richTextView.placeHolder = "input something"
richTextView.limitNumber = 150
```
- **createRichTextView**
```
var emoticonView: EmoticonView?
emoticonView = EmoticonView.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 216.0), bundlePath: bundle!.bundlePath, plistPath: "\(bundle!.bundlePath)/Emoticon.plist")
self.view.addSubview(emoticonView!)
emoticonView?.isHidden = true
emoticonView?.delegate = self
emoticonView?.deleteImage = UIImage.init(named: "compose_emotion_delete")
```

- **extension ViewController**

```
extension ViewController: EmoticonProtocol, RichTextViewDelegate {
    //MARK: RichTextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textContentSize(_ size: CGSize) {
        if size.height < 40 {
            //一行 高度50
            self.inputTextViewHeight.constant = 50.0
        } else {
            //大于一行 14 + size.height
            if size.height > 80.0 {
                self.inputTextViewHeight.constant = 89.0
            } else {
                self.inputTextViewHeight.constant = 14 + size.height
            }
        }
    }
    
    func sendTextString(_ text: String) {
        // 发送
        let model = EmoticonStringModel.init(showString: text)
        self.emotionsArray.append(model)
        self.inputTableView.insertRows(at: [IndexPath.init(row: self.emotionsArray.count - 1, section: 0)], with: .none)
    }
    
    func emoticonInputDidTapText(text: String) {
        self.richTextView.textViewAddEmoticon(text: text)
    }
    
    func emoticonInputDidTapBackspace() {
        self.richTextView.deleteTextViewString()
    }
}
```

- **add images bundle**

```
add .bundle file to project. add Emotion.plist to .bundle. 
Emotion.plist:
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>emoticons</key>
    <array>
        <dict>
            <key>display</key>
            <string>[smile]</string>
            <key>png</key>
            <string>smile.png</string>
            <key>type</key>
            <string>0</string>
        </dict>
        <dict>
            <key>display</key>
            <string>[cry]</string>
            <key>png</key>
            <string>cry.png</string>
            <key>type</key>
            <string>0</string>
        </dict>
    </array>
</dict>
</plist>
```
# Cocoapods

Add pod ```'EmotionTextInput', '~> 1.0.1'``` to your Podfile
Run ```pod install``` or ```pod update```

# Contributing

- If you need help, open an issue.
- If you found a bug, open an issue.
- If you have a new demand, also open an issue.

# MIT License

EmotionTextInput is available under the MIT license. See the LICENSE file for more info.
