//
//  KWSwift.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/26.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation


public struct KWSwiftWrapper<Base> {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// 对象类型协议
/// 涉及到动态添加属性
public protocol KWSwiftCompatible: AnyObject { }

/// 值类型协议
public protocol KWSwiftCompatibleValue { }


extension KWSwiftCompatible {
    
    /// 调用成员方法
    public var kw: KWSwiftWrapper<Self> {
        get { return KWSwiftWrapper(self) }
        set { }
    }
    
    /// 调用静态方法
    static var kw: KWSwiftWrapper<Self>.Type {
        get { return KWSwiftWrapper<Self>.self }
        set { }
    }
}


extension KWSwiftCompatibleValue {
    
    public var kw: KWSwiftWrapper<Self> {
        get { return KWSwiftWrapper(self) }
        set { }
    }
    
    static var kw: KWSwiftWrapper<Self>.Type {
        get { return KWSwiftWrapper<Self>.self }
        set { }
    }
}


extension NSObject: KWSwiftCompatible { }
