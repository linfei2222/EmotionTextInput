//
//  AppConfig.swift
//  RichTextProject
//
//  Created by linfeiCommon on 2020/3/4.
//  Copyright © 2020 XieYouWei. All rights reserved.
//

import Foundation
import UIKit

public func getColorFromHexadecimal(_ rgbValue : Int) -> UIColor{
    return UIColor(red: (CGFloat)((rgbValue & 0xFF0000) >> 16) / 255.0, green: (CGFloat)((rgbValue & 0xFF00) >> 8) / 255.0, blue: (CGFloat)(rgbValue & 0xFF) / 255.0, alpha: 1.0)
}

public func getColorFromHexadecimal(_ rgbValue : Int, alphaValue alpha : CGFloat) -> UIColor{
    return UIColor(red: (CGFloat)((rgbValue & 0xFF0000) >> 16) / 255.0, green: (CGFloat)((rgbValue & 0xFF00) >> 8) / 255.0, blue: (CGFloat)(rgbValue & 0xFF) / 255.0, alpha: alpha)
}

public func safeAreaBottom() -> CGFloat {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
    } else {
        return 0.0
    }
}
