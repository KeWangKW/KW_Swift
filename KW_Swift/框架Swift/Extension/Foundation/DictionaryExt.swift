//
//  DictionaryExt.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/24.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation


extension Dictionary {
    
    subscript(dicForKey key: Key) -> [String: Any]? {
        get { return self[key] as? [String: Any] }
        set { self[key] = newValue as? Value }
    }
    
    subscript(stringForKey key: Key) -> String? {
        get { return self[key] as? String }
        set { self[key] = newValue as? Value }
    }
    
    subscript(nsdicForKey key: Key) -> NSDictionary? {
        get { return self[key] as? NSDictionary }
        set { self[key] = newValue as? Value}
    }
    
    subscript<T>(objForKey key: Key) -> T? {
        get { return self[key] as? T }
        set { self[key] = newValue as? Value}
    }
}
