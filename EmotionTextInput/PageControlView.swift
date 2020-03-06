//
//  PageControlView.swift
//  InteractiveClassPlatform
//
//  Created by linfeiCommon on 2020/1/17.
//  Copyright © 2020 Codyy. All rights reserved.
//

import Foundation
import UIKit

class PageControlView: UIView {
    //default is 2.0
    var controlLayerHeight: CGFloat = 2.0
    var controlHeight: CGFloat? {
        willSet {
            controlLayerHeight = newValue ?? 2.0
        }
    }
    //default is 6.0
    var controlLayerWidth: CGFloat = 6.0
    var controlWidth: CGFloat? {
        willSet {
            controlLayerWidth = newValue ?? 6.0
        }
    }
    //default is 5.0
    var controlSpaceWidth: CGFloat = 5.0
    var spaceWidth: CGFloat? {
        willSet {
            controlSpaceWidth = newValue ?? 5.0
        }
    }
    
    //default is 0
    var controlCount: Int = 0
    var pageControlCount: Int? {
        willSet {
            controlCount = newValue ?? 0
            setPageControlCount(count: controlCount)
        }
    }
    
    //default is 0
    var location: Int = 0
    var pageLocation: Int? {
        willSet {
            location = newValue ?? 0
            refreshControlColor()
        }
    }
    
    //default is UIColor.init(r: 253.0, g: 130.0, b: 37.0)
    var selectLayerColor: UIColor = UIColor.init(red: 253.0, green: 130.0, blue: 37.0, alpha: 1.0)
    var selectColor: UIColor? {
        willSet {
            selectLayerColor = newValue ?? UIColor.init(red: 253.0, green: 130.0, blue: 37.0, alpha: 1.0)
            refreshControlColor()
        }
    }
    
    //default is UIColor.init(r: 222.0, g: 222.0, b: 222.0)
    var nomalLayerColor: UIColor = UIColor.init(red: 222.0, green: 222.0, blue: 222.0, alpha: 1.0)
    var nomalColor: UIColor? {
        willSet {
            nomalLayerColor = newValue ?? UIColor.init(red: 222.0, green: 222.0, blue: 222.0, alpha: 1.0)
            refreshControlColor()
        }
    }
    
    var layerArray: [CALayer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPageControlCount(count: Int) {
        for layer in layerArray {
            layer.removeFromSuperlayer()
        }
        layerArray.removeAll()
        if count == 0 {
            return
        }
        let totalWidth: CGFloat = controlLayerWidth * CGFloat(count) + controlSpaceWidth * CGFloat(count - 1)
        let initialX = (self.frameWidth() - totalWidth) / 2.0
        for i in 0..<count {
            let addLayer = CALayer()
            let addLayerX = initialX + (controlSpaceWidth + controlLayerWidth) * CGFloat(i)
            addLayer.frame = CGRect.init(x: addLayerX, y: 0.0, width: controlLayerWidth, height: controlLayerHeight)
            if i == location {
                addLayer.backgroundColor = selectLayerColor.cgColor
            } else {
                addLayer.backgroundColor = nomalLayerColor.cgColor
            }
            layer.addSublayer(addLayer)
            layerArray.append(addLayer)
        }
    }
    
    private func refreshControlColor() {
        for (index, layer) in layerArray.enumerated() {
            if index == location {
                layer.backgroundColor = selectLayerColor.cgColor
            } else {
                layer.backgroundColor = nomalLayerColor.cgColor
            }
        }
    }
}
