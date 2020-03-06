//
//  UIViewExtend.swift
//  InteractiveClassPlatform
//
//  Created by linfeiCommon on 2019/12/10.
//  Copyright © 2019 Codyy. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func frameX() -> CGFloat {
        return self.frame.origin.x
    }
    
    func setFrameX(_ newX : CGFloat) {
        var newFrame = self.frame
        newFrame.origin.x = newX
        self.frame = newFrame
    }
    
    func frameY() -> CGFloat {
        return self.frame.origin.y
    }
    
    func setFrameY(_ newY : CGFloat) {
        var newFrame = self.frame
        newFrame.origin.y = newY
        self.frame = newFrame
    }
    
    func frameWidth() -> CGFloat {
        return self.frame.size.width
    }
    
    func setFrameWidth(_ newWidth : CGFloat) {
        var newFrame = self.frame
        newFrame.size.width = newWidth
        self.frame = newFrame
    }
    
    func frameHeight() -> CGFloat {
        return self.frame.size.height
    }
    
    func setFrameHeight(_ newHeight : CGFloat) {
        var newFrame = self.frame
        newFrame.size.height = newHeight
        self.frame = newFrame
    }
    
    func frameTop() -> CGFloat {
        return self.frame.origin.y
    }
    
    func setFrameTop(_ newTop : CGFloat) {
        var newFrame = self.frame
        newFrame.origin.y = newTop
        self.frame = newFrame
    }

    func frameBottom() -> CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }

    func setFrameBottom(_ newBottom : CGFloat) {
        var newFrame = self.frame
        newFrame.origin.y = newBottom - self.frame.size.height
        self.frame = newFrame
    }
    
    func frameLeft() -> CGFloat {
        return self.frame.origin.x
    }

    func setFrameLeft(_ newLeft : CGFloat) {
        var newFrame = self.frame
        newFrame.origin.x = newLeft
        self.frame = newFrame
    }

    func frameRight() -> CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }

    func setFrameRight(_ newRight : CGFloat) {
        var newFrame = self.frame
        newFrame.origin.x = newRight - self.frame.size.width
        self.frame = newFrame
    }
    
    func frameCenterX() -> CGFloat {
        return self.center.x
    }
    
    func setFrameCenterX(_ newCenterX : CGFloat) {
        var newCenter = self.center
        newCenter.x = newCenterX
        self.center = newCenter
    }

    func frameCenterY() -> CGFloat {
        return self.center.y
    }
    
    func setFrameCenterY(_ newCenterY : CGFloat) {
        var newCenter = self.center
        newCenter.y = newCenterY
        self.center = newCenter
    }
    
    func frameOrigin() -> CGPoint {
        return self.frame.origin
    }
    
    func setFrameOrigin(_ newOrigin : CGPoint) {
        var newFrame = self.frame
        newFrame.origin = newOrigin
        self.frame = newFrame
    }

    func frameSize() -> CGSize {
        return self.frame.size
    }
    
    func setFrameSize(_ newSize : CGSize) {
        var newFrame = self.frame
        newFrame.size = newSize
        self.frame = newFrame
    }
    
    func setCornerRadius(_ radius: CGFloat) {
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: radius)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func getCurrentVC() -> UIViewController? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let responser = view?.next {
                if responser.isKind(of: UIViewController.self) {
                    return responser as? UIViewController
                }
            }
        }
        return nil
    }
}
