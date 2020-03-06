//
//  DecoderStruct.swift
//  InteractiveClassPlatform
//
//  Created by linfeiCommon on 2020/1/19.
//  Copyright © 2020 Codyy. All rights reserved.
//

import Foundation

struct DecoderStruct {
    public static func decode<T>(_ type: T.Type, param: [String: Any]) -> T? where T: Decodable {
        guard let jsonData = self.getJsonData(with: param) else {
            return nil
        }
        guard let model = try? JSONDecoder().decode(type, from: jsonData) else {
            return nil
        }
        return model
    }
    
    private static func getJsonData(with param: Any) -> Data? {
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }
}
