//
//  UserDefault.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/21.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation


@propertyWrapper
public struct UserDefault<Value> {
    
    private let key: UserDefaultKey
    
    init(_ key: UserDefaultKey) {
        self.key = key
    }
    
    
    public var wrappedValue: Value? {
        get {
            UserDefaults.standard.object(forKey: key.rawValue) as? Value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}


struct UserDefaultKey: RawRepresentable {
    let rawValue: String
}

extension UserDefaultKey: ExpressibleByStringLiteral {
    
    init(stringLiteral value: String) {
        rawValue = value
    }
}

