//
//  UIImageExtend.swift
//  InteractiveClassPlatform
//
//  Created by linfeiCommon on 2020/1/2.
//  Copyright © 2020 Codyy. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /** image processing thread*/
    static var priorityQueue = DispatchQueue(label: "emoticons.images")
    /** image cache map*/
    static var emoticonMap: [String: Data] = [:]
    /** image scale load order*/
    static let screenScale: [NSNumber] = {
        let screenScale = UIScreen.main.scale
        if screenScale <= 1 {
            return [1, 2, 3]
        } else if (screenScale <= 2) {
            return [2, 3, 1]
        } else {
            return [3, 2, 1]
        }
    }()
    
    /**
     preload images into cache
     */
    static func preloadEmoticonCache(loadBundle: Bundle, ofType ext: String, inDirectory path: String) {
        priorityQueue.async {
            let fileArray = loadBundle.paths(forResourcesOfType: ext, inDirectory: path)
            for filePath in fileArray {
                let data = UIImage.emoticonMap[filePath]
                if data == nil {
                    let fileUrl = URL.init(fileURLWithPath: filePath)
                    let bundleData = try? Data.init(contentsOf: fileUrl)
                    if bundleData != nil {
                        UIImage.emoticonMap.updateValue(bundleData!, forKey: filePath)
                    }
                }
            }
        }
    }
    
    /**
    remove images cache
    */
    static func releaseEmoticonCache() {
        priorityQueue.async {
            UIImage.emoticonMap.removeAll()
        }
    }
    
    /**
    get image using file path
    Simple code:
     let bundle = Bundle.init(path: Bundle.main.path(forResource: "Emoticon", ofType: "bundle")!)
     UIImage.emoticonNamed(URL.init(fileURLWithPath: "\(bundle!.bundlePath)/smile@2x.png"), complete: {(image) in
         
     })
     
     let bundle = Bundle.init(path: Bundle.main.path(forResource: "Emoticon", ofType: "bundle")!)
     let imageUrl = UIImage.urlForImageNamed(name: "smile", ofType: "png", inDirectory: "", inBundle: bundle!)
     if imageUrl != nil {
         UIImage.emoticonNamed(imageUrl!, complete: {(image) in
             
         })
     }
    */
    static func emoticonNamed(_ namePath: URL, complete: @escaping (UIImage) -> Void) {
        priorityQueue.async {
            let data = UIImage.emoticonMap[namePath.absoluteString]
            var emoticon : UIImage?
            if data != nil {
                emoticon = UIImage.init(data: data!)
            }
            if emoticon == nil {
                let bundleData = try? Data.init(contentsOf: namePath)
                if bundleData != nil {
                    UIImage.emoticonMap.updateValue(bundleData!, forKey: namePath.absoluteString)
                    emoticon = UIImage.init(data: bundleData!)
                }
            }
            if emoticon != nil {
                DispatchQueue.main.async {
                    complete(emoticon!)
                }
            }
        }
    }
    
    static func getEmoticonNamedInMain(_ namePath: URL) -> UIImage? {
        let data = UIImage.emoticonMap[namePath.absoluteString]
        var emoticon : UIImage?
        if data != nil {
            emoticon = UIImage.init(data: data!)
        }
        if emoticon == nil {
            let bundleData = try? Data.init(contentsOf: namePath)
            if bundleData != nil {
                priorityQueue.async {
                    UIImage.emoticonMap.updateValue(bundleData!, forKey: namePath.absoluteString)
                }
                emoticon = UIImage.init(data: bundleData!)
            }
        }
        if emoticon != nil {
            return emoticon
        }
        return nil
    }
    
    /**
    get image url using file path
    Simple code:
     let bundle = Bundle.init(path: Bundle.main.path(forResource: "Emoticon", ofType: "bundle")!)
     let imageUrl = UIImage.urlForImageNamed(name: "smile", ofType: "png", inDirectory: "", inBundle: bundle!)
    */
    static func urlForImageNamed(name: String, ofType ext: String, inDirectory path: String, inBundle bundle: Bundle) -> URL? {
        if name.count == 0 { return nil }
        if name.hasSuffix("/") {
            let filePath = bundle.path(forResource: name, ofType: ext)
            if filePath == nil { return nil }
            return URL.init(fileURLWithPath: filePath!)
        }
        var fileExistPath : String?
        for scale in UIImage.screenScale {
            let scaledName = (ext.count > 0) ? name.stringByAppendingNameScale(scale: scale as? Int ?? 1) : name.stringByAppendingPathScale(scale: scale as? Int ?? 1)
            fileExistPath = bundle.path(forResource: scaledName, ofType: ext, inDirectory: path)
            if fileExistPath != nil {
                break
            }
        }
        if fileExistPath != nil {
            return URL.init(fileURLWithPath: fileExistPath!)
        } else {
            return nil
        }
    }
}
