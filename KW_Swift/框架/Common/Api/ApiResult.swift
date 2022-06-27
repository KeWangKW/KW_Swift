//
//  ApiResult.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/18.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON


struct ApiResponse {
    
    /// 状态值
    let status: String
    
    /// 提示消息
    let message: String
    
    /// 数据
    let info: AnyObject?
    
    let infoJosn: JSON?
    
    /// 原始数据
    let rawValue: Dictionary<String, Any>?
}

extension ApiResponse {
    
    /// Code值
    var code: Int {
        return Int(status) ?? 0
    }
    
    /// 是否为9999
    var success: Bool {
        return code == ApiError.Code.success.rawValue
    }
    
    /// token失效
    var tokenExpired: Bool {
        return code == ApiError.Code.tokenExpired.rawValue
    }
}

extension ApiResponse {
    
    init(_ response: Moya.Response) {
        do {
            let json = try JSON(data: response.data)
            self.status = json[RESULT_CODE].string ?? json[RESULT_CODE].number?.stringValue ?? ""
            self.message = json[RESULT_MESSAGE].string ?? ""
            self.rawValue = json.dictionaryObject
            self.infoJosn = json[RESULT_DATA]
            self.info = json[RESULT_DATA].object as AnyObject
            isLogout()
        } catch  {
            self.status = ""
            self.message = ""
            self.info = nil
            self.infoJosn = nil
            self.rawValue = nil
        }
        
        #if DEBUG
        print(self.description)
        #endif
    }
    
}

extension ApiResponse: CustomStringConvertible {
    var description: String {
        return "\n↓↓↓↓↓↓↓↓↓↓  网络请求-响应体  ↓↓↓↓↓↓↓↓↓↓\n\(String(describing: self.rawValue))\n↑↑↑↑↑↑↑↑↑↑  网络请求-响应体  ↑↑↑↑↑↑↑↑↑↑\n"
    }
}



enum ApiError: Swift.Error {
    case badServer
    case notFound
    case tokenExpired
    case other(statusCode: Int)
}


extension ApiError {
    var code: Int {
        switch self {
        case .badServer: return ApiError.Code.badServer.rawValue
        case .notFound: return ApiError.Code.notFound.rawValue
        case .tokenExpired: return ApiError.Code.tokenExpired.rawValue
        case .other(let code): return code
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .badServer: return "内部服务器错误"
        case .notFound: return "访问失败-404"
        case .tokenExpired: return "登录状态已过期"
        case .other: return "请求失败"
        }
    }
}

extension ApiError {
    static func transform(_ error: MoyaError) -> ApiError {
        #if DEBUG
        print("\n↓↓↓↓↓↓↓↓↓↓  网络请求-请求失败  ↓↓↓↓↓↓↓↓↓↓\n\(error.localizedDescription)\n↑↑↑↑↑↑↑↑↑↑  网络请求-请求失败  ↑↑↑↑↑↑↑↑↑↑\n")
        #endif
        let code = error.response?.statusCode ?? ApiError.Code.other.rawValue
        guard code != ApiError.Code.notFound.rawValue else {
            return .notFound
        }
        guard code != ApiError.Code.badServer.rawValue else {
            return .badServer
        }
        return .other(statusCode: code)
    }
}


extension ApiError {
    enum Code: Int {
        case badServer = 500
        case notFound = 404
        case other = -9999
        
        case success = 200 //成功
        case tokenExpired = 666 //失效
    }
}
