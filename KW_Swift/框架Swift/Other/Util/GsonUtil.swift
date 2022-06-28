//
//  GsonUtil.swift
//  KW_Swift
//
//  Created by bingxin on 2021/1/14.
//  Copyright © 2021 guan. All rights reserved.
//

import Foundation

import Foundation
class GsonUtil :NSObject{
    
    static func arr2Json(itemList:[Any]) -> String {
        
        let data_A = try? JSONSerialization.data(withJSONObject: itemList, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let jsonStr_A = NSString(data: data_A!, encoding: String.Encoding.utf8.rawValue)
        let jsonStr_A_M:NSMutableString = jsonStr_A as! NSMutableString
        jsonStr_A_M.replacingOccurrences(of: "\\", with: "")
        return jsonStr_A_M as String
    }
}


