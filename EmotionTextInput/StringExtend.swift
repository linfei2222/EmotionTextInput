//
//  StringExtend.swift
//  InteractiveClassPlatform
//
//  Created by linfeiCommon on 2019/12/31.
//  Copyright © 2019 Codyy. All rights reserved.
//

import Foundation
import UIKit

extension String {
    static let regexEmoticon: NSRegularExpression = try! NSRegularExpression.init(pattern: "\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]", options: .caseInsensitive)
    
    func convertToAttributedStringWithExpression(_ convertStr: String, attributes attrs: [NSAttributedString.Key : Any]? = nil, lineSpace space: CGFloat, emoticons map: [String: URL]?) -> NSMutableAttributedString {
        let text = NSMutableAttributedString.init(string: convertStr, attributes: attrs)
        if map != nil {
            let emoticonReult = String.regexEmoticon.matches(in: text.string, options: [], range: rangeOfAll(attString: text))
            var imageArray: [Dictionary<String, Any>] = NSMutableArray.init(capacity: emoticonReult.count) as! [Dictionary<String, Any>]
            for emo in emoticonReult {
                if emo.range.location == NSNotFound && emo.range.length <= 1 {
                    continue
                }
                let substr = text.attributedSubstring(from: emo.range)
                if map![substr.string] == nil {
                    continue
                }
                let font: UIFont = attrs?[.font] as? UIFont ?? UIFont.systemFont(ofSize: 17.0)
                let textAttachment = NSTextAttachment.init()
                textAttachment.bounds = CGRect.init(x: 0, y: -4.0, width: font.pointSize + 3.0, height: font.pointSize + 3.0)
                textAttachment.image = UIImage.getEmoticonNamedInMain(map![substr.string]!)
                let imageStr = NSAttributedString.init(attachment: textAttachment)
                imageArray.insert(["image": imageStr, "range": emo.range], at: 0)
            }
            for imageDic: Dictionary in imageArray {
                text.replaceCharacters(in: imageDic["range"] as! NSRange, with: imageDic["image"] as! NSAttributedString)
            }
        }
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = space
        text.addAttribute(.paragraphStyle, value: paragraphStyle, range: rangeOfAll(attString: text))
        return text
    }
    
    func rangeOfAll(attString: NSAttributedString) -> NSRange {
        return NSRange.init(location: 0, length: attString.length)
    }
    
    static func sizeWithText(_ text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attributedText = NSAttributedString.init(string: text, attributes: [.font: font])
        let rect = attributedText.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.size
    }
    
    static func sizeWithAttributedText(_ attributedText: NSAttributedString, maxSize: CGSize) -> CGSize {
        let rect = attributedText.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.size
    }
    
    static func sizeWithAttributedTextWithLabel(_ attributedText: NSAttributedString, maxSize: CGSize) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = attributedText
        let rect = label.sizeThatFits(maxSize)
        return rect
    }
    
    func stringByAppendingNameScale(scale: Int) -> String {
        if scale == 1 || self.count == 0 || self.hasSuffix("/") {
            return self
        }
        return "\(self)@\(scale)x"
    }
    
    func stringByAppendingPathScale(scale: Int) -> String {
        if scale == 1 || self.count == 0 || self.hasSuffix("/") {
            return self
        }
        let ext = (self as NSString).pathExtension
        var extRanege = NSMakeRange(self.count - ext.count, 0)
        if ext.count > 0 {
            extRanege.location -= 1
        }
        return self.replacingCharacters(in: Range.init(extRanege, in: self)!, with: "@\(scale)x")
    }
}
