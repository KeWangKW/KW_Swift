//
//  KWCommonApi.swift
//  KW_Swift
//
//  Created by 渴望 on 2020/11/18.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation
import Moya

let KWCommonReq = ApiProvider<KWCommonApi>()

enum KWCommonApi{
    case LogIn(params:[String:String])
    case sendForgetVerifyCode(mobile:String)
    case forgetPassword(params:[String:String])
    
    case shopCart(params:[String:String])
}

extension KWCommonApi: ApiTargetType {
    
    var baseURL: URL { //服务器地址
        return URL(string: Api.baseApi)!
    }
    
    var path: String { //请求路径
        
        switch self {
        case .LogIn:
            return "v1/login/login"
        case .sendForgetVerifyCode:
            return "v1/login/sendForgetVerifyCode"
        case .forgetPassword:
            return "v1/login/forgetPassword"
        case .shopCart:
            return "v4/Cart/index"
        }
    }
    
    var method: Moya.Method { //请求方式
        return .post
    }
    
    var sampleData: Data { //模拟参数
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        let encoding: ParameterEncoding = JSONEncoding.default
        
        
        switch self {
        case .LogIn(let params),
             .forgetPassword(let params),
             .shopCart(let params):
            return .requestParameters(parameters: params, encoding: encoding)
        case .sendForgetVerifyCode(let mobile):
            return .requestParameters(parameters: ["mobile":mobile], encoding: encoding)
//        case .shopCart:
//            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let token = UserDefaults.LoginInfo.value(forKey: .tokenXDS_B) as? String ?? ""
        let nowToken = String(format: "%@", token)
        
        return ["Content-type": "application/json" ,
                "token": nowToken ,"x-application-version": App.version ,"scene":"IOS" ]
    }
    
    var validate: Bool {
        return false
    }
}
