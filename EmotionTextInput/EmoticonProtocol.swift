//
//  EmoticonProtocol.swift
//  InteractiveClassPlatform
//
//  Created by linfeiCommon on 2020/1/20.
//  Copyright © 2020 Codyy. All rights reserved.
//

import Foundation

protocol EmoticonProtocol: class {
    func emoticonInputDidTapText(text: String)
    func emoticonInputDidTapBackspace()
}
