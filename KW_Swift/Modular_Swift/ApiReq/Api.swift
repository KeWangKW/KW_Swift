//
//  Api.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/17.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation
import Moya
//0000
//190819
//114414
//000111
//105765

struct Api {
    
    //MARK: 开发环境
//    static let baseOrder = "https://XXXX.com/"
//    static let base = "https://XXXX.com/"
//    static let baseWeb = "https://XXXX.com/"
    //MARK: 演示环境
//    static let base = "https://XXXX.com/"
//    static let baseWeb = "https://XXXX.com/"
    //MARK: 测试环境
//    static let baseOrder = "https://XXXX.com/"
//    static let base = "https://XXXX.com/"
//    static let baseWeb = "https://XXXX.com/"
    //MARK: 预生产环境
//    static let baseOrder = "https://XXXX.com/"
//    static let base = "https://XXXX.com/"
//    static let baseWeb = "https://XXXX.com/"
    //MARK: 正式地址
    static let baseOrder = "https://XXXX.com/"
    static let base = "https://XXXX.com/"
    static let baseWeb = "https://XXXX.com/"
    
    
    //MARK: 地址拼接
    static let baseLogin = Api.base + "login/"
    static let baseApi   = Api.base + "api/"
    static let baseAgent = Api.base + "agent/"
    static let baseSpm   = Api.base + "spm/"
    static let baseOrderApi   = Api.baseOrder + "api/"
    
    
    
    
}

