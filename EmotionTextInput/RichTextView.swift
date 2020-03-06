//
//  RichTextView.swift
//  InteractiveClassPlatform
//
//  Created by linfeiCommon on 2020/1/13.
//  Copyright © 2020 Codyy. All rights reserved.
//

import Foundation
import UIKit

protocol RichTextViewDelegate: UITextViewDelegate {
    func sendTextString(_ text: String)
    func textContentSize(_ size: CGSize)
}

extension RichTextViewDelegate {
    func sendTextString(_ text: String) {
        
    }
    
    func textContentSize(_ size: CGSize) {
        
    }
}

class RichTextView: UITextView,UITextViewDelegate {
    weak var richDelegate: RichTextViewDelegate?
    // Default value: 5.0
    var lineFragmentPadding:CGFloat? {
        willSet {
            changeLineFragmentPadding(padding: newValue ?? 5.0)
        }
    }
    // Default value: 0.5
    var borderWidth:CGFloat? {
        willSet {
            changeBorderWidth(width: newValue ?? 0.5)
        }
    }
    var borderColor:CGColor? {
        willSet {
            changeBorderColor(color: newValue ?? UIColor.gray.cgColor)
        }
    }
    // Default value: 5.0
    var cornerRadius:CGFloat? {
        willSet {
            changeCornerRadius(radius: newValue ?? 5.0)
        }
    }
    // Default value: ""
    var placeHolder:String? {
        willSet {
            showPlaceHolder(spaceHolder: newValue ?? "")
        }
    }
    // Default value: UIColor(red: 0.6, green: 0.6, blue: 0.6,alpha:1)
    var placeHolderColor:UIColor? {
        willSet {
            placeHolderColor(color: newValue ?? UIColor(red: 0.6, green: 0.6, blue: 0.6,alpha:1))
        }
    }
    lazy var holderLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6,alpha:1)
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    // Default value: ""
    var limitValue: Int = 0
    var limitNumber:Int? {
        willSet {
            showLimitNumber(limitNumber: newValue ?? 0)
            limitValue = newValue ?? 0
        }
    }
    // Default value: UIColor(red: 0.78, green: 0.78, blue: 0.78,alpha:1)
    var limitNumberColor:UIColor? {
        willSet {
            limitNumberColor(color: newValue ?? UIColor(red: 0.78, green: 0.78, blue: 0.78,alpha:1))
        }
    }
    lazy var limitLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.78,alpha:1)
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .right
        return label
    }()
//    override var frame: CGRect {
//        willSet {
//            super.frame = newValue
//            holderLabel.frame = CGRect.init(x: 5.0, y: (newValue.height - 13.0) / 2.0, width: newValue.width - 50.0 - 5.0, height: 13.0)
//        }
//    }
    
    private override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initLoadView()
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLoadView() {
        changeLineFragmentPadding(padding: 5.0)
        changeBorderWidth(width: 0.5)
        changeBorderColor(color: UIColor.gray.cgColor)
        changeCornerRadius(radius: 5.0)
        self.delegate = self
        self.returnKeyType = .send
        holderLabel.frame = CGRect.init(x: self.textContainer.lineFragmentPadding, y: (self.frame.height - 13.0) / 2.0, width: self.frame.width - 50.0 - self.textContainer.lineFragmentPadding, height: 13.0)
        holderLabel.text = ""
        holderLabel.backgroundColor = .clear
        addSubview(holderLabel)
        limitLabel.frame = CGRect.init(x: self.frame.width - self.textContainer.lineFragmentPadding - 50.0, y: (self.frame.height - 12.0) / 2.0, width: 50.0, height: 12.0)
        limitLabel.text = ""
        limitLabel.backgroundColor = .clear
        addSubview(limitLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        holderLabel.frame = CGRect.init(x: self.textContainer.lineFragmentPadding, y: (self.frame.height - 13.0) / 2.0, width: self.frame.width - 50.0 - self.textContainer.lineFragmentPadding, height: 13.0)
        limitLabel.frame = CGRect.init(x: self.frame.width - self.textContainer.lineFragmentPadding - 50.0, y: (self.frame.height - 12.0) / 2.0, width: 50.0, height: 12.0)
    }
    
    func changeBorderWidth(width: CGFloat) {
        self.layer.borderWidth = width
    }
    
    func changeBorderColor(color: CGColor) {
        self.layer.borderColor = color
    }
    
    func changeCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func changeLineFragmentPadding(padding: CGFloat) {
        self.textContainer.lineFragmentPadding = padding
        holderLabel.setFrameX(padding)
        limitLabel.setFrameRight(padding)
    }
    
    func showPlaceHolder(spaceHolder: String) {
        holderLabel.text = spaceHolder
    }
    
    func placeHolderColor(color: UIColor) {
        holderLabel.textColor = color
    }
    
    func showLimitNumber(limitNumber: Int) {
        limitLabel.text = limitNumber > 0 ? "\(limitNumber)" : ""
    }
    
    func limitNumberColor(color: UIColor) {
        limitLabel.textColor = color
    }
    
    //add emoticon string
    func textViewAddEmoticon(text: String) {
        let rangeExist = Range.init(self.selectedRange, in: self.text)
        if rangeExist == nil {
            return
        }
        let newString = self.text.replacingCharacters(in: rangeExist!, with: text)
        self.holderLabel.isHidden = (newString.count > 0)
        self.limitLabel.isHidden = (newString.count > 0)
        if limitValue > 0 && newString.count > limitValue{
            return
        }
        self.text = newString
        self.richDelegate?.textContentSize(self.contentSize)
    }
    
    //delete textview text string
    func deleteTextViewString() {
        if self.text.count == 0 {
            return
        }
//        let endString = self.text[self.text.index(self.text.endIndex, offsetBy: -1)..<self.text.endIndex]
//        if endString == "]" {
//            let range = self.text.range(of: "[", options: .backwards, range: nil, locale: nil)
//
//        }
        let rangeExist = Range.init(NSRange.init(location: self.selectedRange.location - 1, length: 1), in: self.text)
        if rangeExist == nil {
            return
        }
        let newString = self.text.replacingCharacters(in: rangeExist!, with: "")
        self.holderLabel.isHidden = (newString.count > 0)
        self.limitLabel.isHidden = (newString.count > 0)
        self.text = newString
        self.richDelegate?.textContentSize(self.contentSize)
    }
}

extension RichTextView {
    //MARK: UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let beginEdit = self.richDelegate?.textViewShouldBeginEditing?(textView) ?? true
        return beginEdit
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let endEdit = self.richDelegate?.textViewShouldEndEditing?(textView) ?? true
        return endEdit
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.richDelegate?.textViewDidEndEditing?(textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.richDelegate?.textViewDidEndEditing?(textView)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let shouldChange = self.richDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
        
        if text == "\n" {
            self.resignFirstResponder()
            if textView.text.count > 0 {
                self.richDelegate?.sendTextString(textView.text)
                textView.text = ""
                self.holderLabel.isHidden = false
                self.limitLabel.isHidden = false
                self.richDelegate?.textContentSize(textView.contentSize)
            }
            return false
        }
        if shouldChange {
            //allow modify
            let rangeExist = Range.init(range, in: textView.text)
            if rangeExist == nil {
                return shouldChange
            }
            let newString = textView.text.replacingCharacters(in: rangeExist!, with: text)
            self.holderLabel.isHidden = (newString.count > 0)
            self.limitLabel.isHidden = (newString.count > 0)
            if limitValue > 0 && newString.count > limitValue{
                return false
            }
        }
        return shouldChange
    }

    func textViewDidChange(_ textView: UITextView) {
        self.richDelegate?.textViewDidChange?(textView)
        self.richDelegate?.textContentSize(textView.contentSize)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        self.richDelegate?.textViewDidChangeSelection?(textView)
    }

    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let shouldInteract = self.richDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
        return shouldInteract
    }

    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let shouldInteract = self.richDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
        return shouldInteract
    }

    @available(iOS, introduced: 7.0, deprecated: 10.0)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let shouldInteract = self.richDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange) ?? true
        return shouldInteract
    }

    @available(iOS, introduced: 7.0, deprecated: 10.0)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        let shouldInteract = self.richDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange) ?? true
        return shouldInteract
    }
}
