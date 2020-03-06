//
//  ViewController.swift
//  RichTextProject
//
//  Created by linfeiCommon on 2020/3/4.
//  Copyright © 2020 XieYouWei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var richTextView: RichTextView = RichTextView.init(frame: .zero)
    lazy var emoticonBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "expression"), for: .normal)
        return btn
    }()
    var emoticonView: EmoticonView?
    
    @IBOutlet weak var inputTextView: UIView!
    @IBOutlet weak var inputTableView: UITableView!
    @IBOutlet weak var inputTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var inputTextViewBottom: NSLayoutConstraint!
    
    var emotionsArray : [EmoticonStringModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle.init(path: Bundle.main.path(forResource: "Emoticon", ofType: "bundle")!)
        emoticonView = EmoticonView.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 216.0), bundlePath: bundle!.bundlePath, plistPath: "\(bundle!.bundlePath)/Emoticon.plist")
        self.view.addSubview(emoticonView!)
        emoticonView?.isHidden = true
        emoticonView?.delegate = self
        emoticonView?.deleteImage = UIImage.init(named: "compose_emotion_delete")
        
        inputTextView.addSubview(richTextView)
        inputTextView.addSubview(emoticonBtn)
        richTextView.translatesAutoresizingMaskIntoConstraints = false
        emoticonBtn.translatesAutoresizingMaskIntoConstraints = false
        richTextView.richDelegate = self
        
        let widthEmoticon = NSLayoutConstraint.init(item: emoticonBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 50.0)
        let rightEmoticon = NSLayoutConstraint.init(item: emoticonBtn, attribute: .right, relatedBy: .equal, toItem: inputTextView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let topEmoticon = NSLayoutConstraint.init(item: emoticonBtn, attribute: .top, relatedBy: .equal, toItem: inputTextView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomEmoticon = NSLayoutConstraint.init(item: emoticonBtn, attribute: .bottom, relatedBy: .equal, toItem: inputTextView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        inputTextView.addConstraints([widthEmoticon, rightEmoticon, topEmoticon, bottomEmoticon])
        
        let left = NSLayoutConstraint.init(item: richTextView, attribute: .left, relatedBy: .equal, toItem: inputTextView, attribute: .left, multiplier: 1.0, constant: 15.0)
        let right = NSLayoutConstraint.init(item: richTextView, attribute: .right, relatedBy: .equal, toItem: emoticonBtn, attribute: .left, multiplier: 1.0, constant: 0.0)
        let top = NSLayoutConstraint.init(item: richTextView, attribute: .top, relatedBy: .equal, toItem: inputTextView, attribute: .top, multiplier: 1.0, constant: 8.0)
        let bottom = NSLayoutConstraint.init(item: richTextView, attribute: .bottom, relatedBy: .equal, toItem: inputTextView, attribute: .bottom, multiplier: 1.0, constant: -8.0)
        inputTextView.addConstraints([left, top, right, bottom])
        
        let tipSingle = UITapGestureRecognizer.init(target: self, action: #selector(dismisKeyBoard))
        inputTableView.addGestureRecognizer(tipSingle)
        
        richTextView.backgroundColor = getColorFromHexadecimal(0xF7F7F7)
        richTextView.borderColor = getColorFromHexadecimal(0xEAEAEA).cgColor
        richTextView.lineFragmentPadding = 15.0
        richTextView.font = UIFont.systemFont(ofSize: 14.0)
        richTextView.textColor = getColorFromHexadecimal(0x333333)
        richTextView.placeHolder = "输入文字"
        richTextView.limitNumber = 150
        
        emoticonBtn.addTarget(self, action: #selector(showEmoticon), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboradWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardHeight = keyboardRect?.height
        inputTextViewBottom.constant = -(keyboardHeight ?? 0.0)
        emoticonView?.isHidden = true
        emoticonView?.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 216.0)
    }
        
    @objc func keyboradWillHide(notification: Notification) {
        if emoticonView?.isHidden ?? true {
            resetInputView()
        }
    }
        
    @objc func keyboardWillChangeFrame(notification: Notification) {
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func dismisKeyBoard() {
        UIApplication.shared.keyWindow?.endEditing(true)
        resetInputView()
    }
    
    @objc func showEmoticon() {
        UIApplication.shared.keyWindow?.endEditing(true)
        inputTextViewBottom.constant = -(emoticonView?.frame.height ?? 0.0)
        emoticonView?.isHidden = false
        emoticonView?.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 216.0 - safeAreaBottom(), width: UIScreen.main.bounds.size.width, height: 216.0)
    }
    
    func resetInputView() {
        inputTextViewBottom.constant = 0.0
        emoticonView?.isHidden = true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emotionsArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let model = self.emotionsArray[indexPath.row]
        cell.emotionTextLabel.attributedText = model.attributedContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.emotionsArray[indexPath.row]
        let height = model.contentHeight + 24.0
        return height > 44.0 ? height : 44.0
    }
}


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

let emoticonsImagesUrl: [String: URL] = {
    var images: [String: URL] = [:]
    let bundle = Bundle.init(path: Bundle.main.path(forResource: "Emoticon", ofType: "bundle")!)
    guard let plistDic: NSDictionary = NSDictionary.init(contentsOfFile: "\(bundle!.bundlePath)/Emoticon.plist") else {
        return images
    }
    guard let  array = plistDic["emoticons"] as? Array<Dictionary<String, Any>> else {
        return images
    }
    for obj in array {
        let url = UIImage.urlForImageNamed(name: ((obj["png"] as! NSString).deletingPathExtension as NSString).lastPathComponent, ofType: (obj["png"] as! NSString).pathExtension, inDirectory: (obj["png"] as! NSString).deletingLastPathComponent, inBundle: bundle!)
        if url == nil {
            continue
        }
        images.updateValue(url!, forKey: obj["display"] as! String)
    }
    return images
}()

struct EmoticonStringModel {
    var contentHeight: CGFloat //宽度是UIScreen.main.bounds.size.width-40
    var attributedContent: NSAttributedString //富文
    
    init(showString string: String) {
        attributedContent = string.convertToAttributedStringWithExpression(string, attributes: [.foregroundColor: getColorFromHexadecimal(0x333333), .font: UIFont.systemFont(ofSize: 13.0)], lineSpace: 2.0, emoticons:emoticonsImagesUrl)
        let size = String.sizeWithAttributedText(self.attributedContent, maxSize: CGSize.init(width: UIScreen.main.bounds.size.width - 40, height: CGFloat.greatestFiniteMagnitude))
        self.contentHeight = size.height
    }
}

class TableViewCell: UITableViewCell {
    @IBOutlet weak var emotionTextLabel: UILabel!
}
