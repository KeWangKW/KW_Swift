//
//  UserDefaultConst.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/21.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation


extension UserDefaultKey {
    static let token: UserDefaultKey = "AppTokenKey"
}







/**
 UserDefaults的另一种实现方式
 对于 `nil` 类型的处理还不完善
  */
 
protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}

protocol UserDefaultsSaveable {}

extension UserDefaultsSettable where defaultKeys.RawValue == String {
    
    static func set(value: UserDefaultsSaveable?, forKey key: defaultKeys) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func value(forKey key: defaultKeys) -> UserDefaultsSaveable? {
        return UserDefaults.standard.value(forKey: key.rawValue) as UserDefaultsSaveable
    }
    
    static func remove(forKey key: defaultKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
}


extension UserDefaults {
    struct LoginInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case tokenXDS_B
            case phone
            case password
            case projectID
            case projectName
            case QuanXian
        }
    }
    
    struct AddressMsg: UserDefaultsSettable {
        enum defaultKeys: String {
            case name
            case ids
        }
    }
    
    struct Home: UserDefaultsSettable {
        enum defaultKeys: String {
            case area
            case areaName
        }
    }
    
    struct Guide: UserDefaultsSettable {
        enum defaultKeys: String {
            case guide
            case guide1
        }
    }
    
    struct Circle: UserDefaultsSettable {
        enum defaultKeys: String {
            case agree
            case shieldingIds
            case shieldingUsers
        }
    }
    
    
}


extension String: UserDefaultsSaveable { }

extension Bool:  UserDefaultsSaveable { }

extension Optional: UserDefaultsSaveable { }

extension Array: UserDefaultsSaveable { }


