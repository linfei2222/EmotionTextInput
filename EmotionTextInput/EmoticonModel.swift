//
//  EmoticonModel.swift
//  InteractiveClassPlatform
//
//  Created by linfeiCommon on 2020/1/19.
//  Copyright © 2020 Codyy. All rights reserved.
//

import Foundation

struct EmoticonModel: Codable {
    var display: String = ""
    var png: String = ""
    var type: String = ""
    var pathUrl: URL?
}
